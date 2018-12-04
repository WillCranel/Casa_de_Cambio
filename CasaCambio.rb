class CasaCambio
	attr_accessor :cota, :dol_disp, :rs_disp, :lista_t, :i

	def initialize(cota, dol_disp, rs_disp, lista_t = [], i = 1)
		@cota = cota
		@dol_disp = dol_disp
		@rs_disp = rs_disp
		@lista_t = lista_t
		@i = i
	end

	def negociar(dolar, disp, sif_moeda, tipo, moeda, calc)
		# Recebe o valor do usuário
		print 'Insira a quantia que deseja: '
		valor = gets.to_f
		# Calcula o valor total/final da transação
		total = dolar ? (valor * @cota).round(2) : (valor / @cota).round(2)

		# Verifica se existe a quantia suficiente em caixa
		caixa = disp ? @dol_disp : @rs_disp
		if valor > caixa
			puts 'Desculpe, não possuo essa quantia dessa moeda.'
			puts
		else
			print "O valor final da transação é de #{ sif_moeda } #{ total }. Deseja confirmar a operação? (S/N)"
			continuar = gets.chomp()
			continuar = continuar.upcase == 'S' ? true : false

			# Se confirmar, cria uma Transação e altera o caixa
			if continuar
				@lista_t << Transacao.new(@i, tipo, moeda, @cota, valor)
				if calc == 1
					@dol_disp -= valor
					@rs_disp += total
				elsif calc == 2
					@dol_disp += valor
					@rs_disp -= total
				elsif calc == 3
					@dol_disp += total
					@rs_disp -= valor
				elsif calc == 4
					@dol_disp -= total
					@rs_disp += valor
				end
				@i += 1
				puts "Operação realizada com sucesso! Deseja fazer algo mais?"
				puts
			else
				puts 'Ok, deseja fazer algo mais?'
				puts
			end
		end
	end
end