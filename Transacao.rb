require 'sqlite3'

class Transacao
	attr_accessor :id, :tipo, :moeda, :cota, :total

	def initialize(id_caixa, tipo, moeda, cota, total)
		@tipo = tipo
		@moeda = moeda
		@cota = cota
		@total = total

		salvar(id_caixa)
	end

	def salvar(id_caixa)
		# Conecta ao banco e faz o INSERT
		db = SQLite3::Database.open 'DB_CAMBIO'
		db.execute("INSERT INTO TB_TRANSACOES (TB_CAIXAS_idCaixa, tipoTransacao, moedaTransacao, cotaTransacao, totalTransacao) VALUES (?, ?, ?, ?, ?);", [id_caixa, @tipo, @moeda, @cota, @total])
		db.close
	end
end