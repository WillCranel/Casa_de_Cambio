require "terminal-table"
require_relative 'Transacao'
require_relative 'CasaCambio'

def welcome()
	puts 'Bem Vindo a Casa de Cambio via Terminal!'
	puts
	puts 'Por favor, preencha os dados pedidos a seguir:'

	# Armazena as informações necessárias em um array
	caixa = []
	print 'Insira a cotação atual do dolar: '
	caixa << gets.to_f
	print 'Insira o valor total disponivel de Dólares: '
	caixa << gets.to_f
	print 'Insira o valor total disponivel de Reais: '
	caixa << gets.to_f
	puts

	# Retorna o array caixa
	caixa
end

def menu()
	# Exibe as opções existentes no menu
	puts '[1] Comprar dólares'
	puts '[2] Vender dólares'
	puts '[3] Comprar reais'
	puts '[4] Vender reais'
	puts '[5] Ver operações do dia'
	puts '[6] Ver situação do caixa'
	puts '[7] Salvar'
	puts '[8] Sair'
	puts
	print 'Escolha uma opção: '

	# Recebe a entrada do usuário
	gets.to_i
end

# Salva as Transações do dia em um arquivo texto
def salvar(lista)
	File.open('transacoes.txt', 'w') do |file|
		lista.each do |t| 
			file.write(t.id.to_s + "\n" + t.tipo + "\n" + t.moeda + "\n" + t.cota.to_s + "\n" + t.total.to_s + "\n")
		end
	end
end
# Carrega as Transações do dia de um arquivo texto
def carregar
	lista_transacoes = []
	id, tipo, moeda, cota, total = ''
	count = 1

	File.open('transacoes.txt', 'r') do |file|
		file.each_line do |line|
			#Pula as linhas em branco
			lin = line.chomp
			if(!lin.empty?)
				#Verifica qual variavel armazenar
				if(count == 1)
					id = lin.to_i
				elsif (count == 2)
					tipo = lin
				elsif (count == 3)
					moeda = lin
				elsif (count == 4)
					cota = lin.to_f
				elsif (count == 5)
					total = lin.to_f
					lista_transacoes << Transacao.new(id, tipo, moeda, cota, total)
					count = 0
				end
				count = count + 1
			end
		end
	end
	lista_transacoes
end

# Armazena os dados inseridos pelo usuário ao abrir o caixa
caixa = welcome
# Instancia uma CasaCambio
lista_transacoes = carregar
i = lista_transacoes[-1].id + 1
cc = CasaCambio.new(caixa[0], caixa[1], caixa[2], lista_transacoes, i)

# Imprime e recebe a opção selecionada pelo usuário
op = menu

# Executa a opção selecionada
while op != 8 do
	if op == 1
		cc.negociar(true, true, 'R$', 'venda', 'dolar', 1)
	elsif op == 2
		cc.negociar(true, false, 'R$', 'compra', 'dolar', 2)
	elsif op == 3
		cc.negociar(false, false, '$', 'venda', 'real', 3)
	elsif op == 4
		cc.negociar(false, true, '$', 'compra', 'real', 4)
	elsif op == 5
		report_table = Terminal::Table.new :title => "Relatório de Operações" do |t|
			t.headings = 'Código', 'Tipo', 'Moeda', 'Cotação no dia', 'Valor Total'
			# Adiciona uma linha para cada transação
			cc.lista_t.each do | transacao |
				t << [transacao.id, transacao.tipo , transacao.moeda , "$ #{transacao.cota}" , "$ #{transacao.total}"]
			end
		end
		puts report_table
	elsif op == 6
		report_table = Terminal::Table.new :title => "Relatório de Caixa" do |t|
		t.headings = 'Cotação Dolar', 'Dólares disponiveis', 'Reais disponiveis'
		t << ["$ #{cc.cota}",  "$ #{cc.dol_disp}", "R$ #{cc.rs_disp}"]
		end
		puts report_table
	elsif op == 7
		salvar(cc.lista_t)
	else
		puts 'Saindo..'
	end

	op = menu
end