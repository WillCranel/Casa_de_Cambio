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
	print 'Insira o valor total disponivel (em dólares): '
	caixa << gets.to_f
	print 'Insira o valor total disponivel (em reais): '
	caixa << gets.to_f

	# Retorna o array caixa
	puts 'Obrigado!'
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
	puts '[7] Sair'
	puts
	print 'Escolha uma opção: '

	# Recebe a entrada do usuário
	gets.to_i
end

# Armazena os dados inseridos pelo usuário ao abrir o caixa
caixa = welcome
# Instancia uma CasaCambio
cc = CasaCambio.new(caixa[0], caixa[1], caixa[2])

# Imprime e recebe a opção selecionada pelo usuário
op = menu

# Executa a opção selecionada
while op != 7 do
	if op == 1
		cc.negociar(true, true, 'R$', 'venda', 'dolar', 1)
	elsif op == 2
		cc.negociar(true, false, 'R$', 'compra', 'dolar', 2)
	elsif op == 3
		cc.negociar(false, false, '$', 'venda', 'real', 3)
	elsif op == 4
		cc.negociar(false, true, '$', 'compra', 'real', 4)
	elsif op == 5
		cc.lista_t.each  do | t |
			t.exibir()
		end
	elsif op == 6
		puts 'Relatório de caixa'
		puts '----------------------------------'
		puts "Cotação do dólar: #{ cc.cota }"
		puts "Dólares disponiveis: #{ cc.dol_disp }"
		puts "Reais disponiveis: #{ cc.rs_disp }"
		puts
	else
		puts 'Saindo..'
	end

	op = menu
end