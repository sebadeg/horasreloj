class PrincipalController < ApplicationController
  def index
  	@hora = Hora.new
	@horas = Hora.all
  end

  def entrar
  	Hora.create(tipo:1, hora:DateTime.now)
  	redirect_to root_path
  end

  def salir
  	Hora.create(tipo:2, hora:DateTime.now)
  	redirect_to root_path
  end

end
