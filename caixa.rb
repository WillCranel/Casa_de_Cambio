require "terminal-table"
require_relative 'Transacao'

class Caixa
	attr_accessor :cota, :dol_disp, :rs_disp, :lista_t

	def initialize()
		puts 'Bem Vindo a Casa de Cambio via Terminal!'
		puts
		puts 'Por favor, preencha os dados pedidos a seguir:'

		# Armazena as informações necessárias
		print 'Insira a cotação atual do dolar: '
		@cota = gets.to_f
		print 'Insira o valor total disponivel de Dólares: '
		@dol_disp = gets.to_f
		print 'Insira o valor total disponivel de Reais: '
		@rs_disp = gets.to_f
		puts

		@lista_t = []
	end

	def negociar(dolar, disp, valor, tipo, calc)
		# Determina qual a moeda
		sif_moeda = dolar ? 'R$' : '$'
		moeda = dolar ? 'dollar' : 'real'

		# Calcula o valor total/final da transação
		total = dolar ? (valor * @cota).round(2) : (valor / @cota).round(2)

		# Verifica se existe a quantia suficiente em caixa
		caixa_disp = disp ? @dol_disp : @rs_disp
		if tipo == 'venda' ? valor > caixa_disp : total > caixa_disp
			puts caixa_disp
			puts 'Desculpe, não possuo essa quantia dessa moeda.'
			puts
		else
			puts caixa_disp
			print "O valor final da transação é de #{ sif_moeda } #{ total }. Deseja confirmar a operação? (S/N)"
			continuar = gets.chomp()

			# Se confirmar, cria uma Transação e altera o caixa_disp
			if continuar.upcase == 'S'
				@lista_t << Transacao.new(@i, tipo, moeda, @cota, valor)
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
				return "Operação realizada com sucesso! Deseja fazer algo mais?"
			else
				return 'Ok, deseja fazer algo mais?'
			end
		end
	end

	def lista_transacoes
		tabela = Terminal::Table.new :title => "Relatório de Operações" do |t|
			t.headings = 'Código', 'Tipo', 'Moeda', 'Cotação no dia', 'Valor Total'
			# Adiciona uma linha para cada transação
			@lista_t.each do | transacao |
				t << [transacao.id, transacao.tipo , transacao.moeda , "$ #{transacao.cota}" , "$ #{transacao.total}"]
			end
		end
		tabela
	end

	def balanco
		tabela = Terminal::Table.new :title => "Relatório de Caixa" do |t|
			t.headings = 'Cotação Dolar', 'Dólares disponiveis', 'Reais disponiveis'
			t << ["$ #{@cota}",  "$ #{@dol_disp}", "R$ #{@rs_disp}"]
		end
		tabela
	end
end