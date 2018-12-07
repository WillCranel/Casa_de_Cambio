require_relative 'Transacao'
require_relative 'Caixa'

# Instancia um objeto Caixa
caixa = Caixa.new()

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

# Executa a opção selecionada
loop do
	case menu
	when 1
		# Vende Dólares
		print 'Insira a quantia que deseja comprar: '
		valor = gets.to_f
		puts caixa.negociar(true, true, valor, 'venda', 1)
		puts
	when 2
		# Compra Dólares
		print 'Insira a quantia que deseja vender: '
		valor = gets.to_f
		puts caixa.negociar(true, false, valor, 'compra', 2)
		puts
	when 3
		# Vende Reais
		print 'Insira a quantia que deseja comprar: '
		valor = gets.to_f
		puts caixa.negociar(false, false, valor, 'venda', 3)
		puts
	when 4
		# Compra Reais
		print 'Insira a quantia que deseja vender: '
		valor = gets.to_f
		puts caixa.negociar(false, true, valor, 'compra', 4)
		puts
	when 5
		# Exibe as transações
		puts caixa.lista_transacoes
		puts
	when 6
		# Exibe a situação atual do caixa
		puts caixa.balanco
		puts
	when 7
		# Fecha o sistema
		puts 'Obrigado, volte sempre!'
		exit 0
	else
		puts 'Opção inválida.'
	end
end