require 'sqlite3'
require 'terminal-table'
require_relative 'Transacao'

class Caixa
	attr_accessor :id, :nome, :cota, :dol_disp, :rs_disp

	def initialize
		puts 'Bem Vindo a Casa de Cambio via Terminal!'
		puts
		puts 'Por favor, preencha os dados pedidos a seguir:'
		print 'Insira seu nome: '
		@nome = gets.chomp

		if caixa_dia
			puts
			puts balanco
			puts
			print 'Deseja atualizar esses dados? (S/N)'
			atualizar = gets.chomp
			if atualizar.upcase == 'S'
				obter_caixa
				salvar
			end
		else
			obter_caixa
			salvar
		end
	end

	def caixa_dia
		# Conecta ao banco e faz o SELECT
		db = SQLite3::Database.open 'DB_CAMBIO'
		db.results_as_hash = true
		caixas = db.execute("SELECT * FROM TB_CAIXAS WHERE dataCaixa = ?", [Time.now.strftime('%D')])
		db.close
		# Salva os resultados em suas devidas variaveis
		if !caixas.empty?
			caixas.each do | caixa |
				@id = caixa['idCaixa']
				@cota = caixa['cotaCaixa']
				@dol_disp = caixa['dolaresCaixa']
				@rs_disp = caixa['reaisCaixa']
			end
			return true
		end
		false
	end

	def obter_caixa
		# Armazena as informações necessárias
		print 'Insira a cotação atual do dolar: '
		@cota = gets.to_f
		print 'Insira o valor total disponivel de Dólares: '
		@dol_disp = gets.to_f
		print 'Insira o valor total disponivel de Reais: '
		@rs_disp = gets.to_f
		puts
	end

	def negociar(dolar, disp, valor, tipo, calc)
		# Determina qual a moeda
		sif_moeda = dolar ? 'R$' : '$'
		moeda = dolar ? 'dolar' : 'real'

		# Calcula o valor total/final da transação
		total = dolar ? (valor * @cota).round(2) : (valor / @cota).round(2)

		# Verifica se existe a quantia suficiente em caixa
		caixa_disp = disp ? @dol_disp : @rs_disp
		if tipo == 'venda' ? valor > caixa_disp : total > caixa_disp
			puts 'Desculpe, não possuo essa quantia dessa moeda.'
			puts
		else
			print "O valor final da transação é de #{ sif_moeda } #{ total.round(2) }. Deseja confirmar a operação? (S/N)"
			continuar = gets.chomp()

			# Se confirmar, cria uma Transação e altera o caixa_disp
			if continuar.upcase == 'S'
				Transacao.new(@id, tipo, moeda, @cota, dolar ? valor.round(2) : total.round(2))
				case calc
					when 1
						@dol_disp -= valor
						@rs_disp += total
					when 2
						@dol_disp += valor
						@rs_disp -= total
					when 3
						@dol_disp += total
						@rs_disp -= valor
					when 4
						@dol_disp -= total
						@rs_disp += valor
				end
				# Conecta ao banco e faz o UPDATE
				db = SQLite3::Database.open 'DB_CAMBIO'
				db.execute("UPDATE TB_CAIXAS SET dolaresCaixa = ?, reaisCaixa = ? WHERE idCaixa = ?", [@dol_disp, @rs_disp, @id])
				db.close
				'Operação realizada com sucesso! Deseja fazer algo mais?'
			else
				'Ok, deseja fazer algo mais?'
			end
		end
	end

	def lista_transacoes
		tabela = Terminal::Table.new :title => "Relatório de Operações" do |t|
			t.headings = 'Código', 'Tipo', 'Moeda', "Cotação\nno dia", "Valor\nTotal"
			# Conecta ao banco e faz o SELECT
			db = SQLite3::Database.open 'DB_CAMBIO'
			db.results_as_hash = true
			transacoes = db.execute("SELECT * FROM TB_TRANSACOES WHERE TB_CAIXAS_idCaixa = ?", [@id])
			db.close
			# Adiciona uma linha para cada transação
			transacoes.each do | transacao |
				t << [transacao['idTransacao'], transacao['tipoTransacao'] , transacao['moedaTransacao'] , "$ #{transacao['cotaTransacao']}" , "$ #{transacao['totalTransacao']}"]
			end
		end
		tabela
	end

	def balanco
		tabela = Terminal::Table.new :title => "Relatório de Caixa" do |t|
			# Conecta ao banco e faz o SELECT
			db = SQLite3::Database.open 'DB_CAMBIO'
			db.results_as_hash = true
			caixa_info = db.execute("SELECT * FROM TB_CAIXAS WHERE idCaixa = ?", [@id])
			db.close
			t.headings = "Cotação\nDolar", "Dólares\ndisponiveis", "Reais\ndisponiveis"
			caixa_info.each do | caixa |
				t << ["$ #{caixa['cotaCaixa']}",  "$ #{caixa['dolaresCaixa']}", "R$ #{caixa['reaisCaixa']}"]
			end
		end
		tabela
	end

	def salvar
		# Conecta ao banco e faz o INSERT
		db = SQLite3::Database.open 'DB_CAMBIO'
		db.execute("INSERT INTO TB_CAIXAS (nomeCaixa, dataCaixa, cotaCaixa, dolaresCaixa, reaisCaixa) VALUES (? , ?, ?, ?, ?)", [@nome, Time.now.strftime('%D'), @cota, @dol_disp, @rs_disp])
		# Armazena o idCaixa na variavel @id
		@id = db.execute("SELECT last_insert_rowid()")
		db.close
	end
end