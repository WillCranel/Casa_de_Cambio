class Transacao
	attr_accessor :id, :tipo, :moeda, :cota, :total

	def initialize(id, tipo, moeda, cota, total)
		@id = id
		@tipo = tipo
		@moeda = moeda
		@cota = cota
		@total = total
	end

	def exibir
		puts "Operação: Código #{ @id }"
		puts "Tipo: #{ @tipo }"
		puts "Moeda: #{ @moeda }"
		puts "Cotação no dia: #{ @cota }"
		puts "Valor Total: $ #{ total }"
		puts '---------------------------------------'
		puts
	end
end