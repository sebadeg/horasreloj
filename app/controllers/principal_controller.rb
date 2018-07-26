class PrincipalController < ApplicationController
  def index
  	@hora = Hora.new

    hoy = DateTime.now

    @suma = 0

    comienzo = nil


    horas = Hora.where("extract(month FROM hora)::int=#{hoy.month} AND extract(year FROM hora)::int=#{hoy.year}").order(hora: :asc)
    horas.each do |h|
      if (h.tipo==1)
        if ( comienzo == nil )
          comienzo = h.hora
        end
      elsif (h.tipo==2)
        if comienzo != nil 
          @suma = @suma + (h.hora-comienzo).to_i
          comienzo=nil
        end
      end
    end

    if ( comienzo != nil)
        @suma = @suma + (hora:DateTime.now-3.hours-comienzo).to_i
    end


    @elements = Hora.where("extract(month FROM hora)::int=#{hoy.month} AND extract(year FROM hora)::int=#{hoy.year}").order(hora: :desc)
  end

  def entrar
  	Hora.create(tipo:1, hora:DateTime.now-3.hours)
  	redirect_to root_path
  end

  def salir
  	Hora.create(tipo:2, hora:DateTime.now-3.hours)
  	redirect_to root_path
  end



  def result(outputHTML,outputJSON)
    respond_to do |format|
      format.html { 
        if outputHTML != nil
          redirect_to outputHTML
        end      
      }
      format.json { 
        if outputJSON != nil
          render :json => outputJSON, :status => :ok
        else
          render :json => "", :status => :bad_request
        end
      }
    end
  end

  def show    
    redirect_to root_path
  end

  def new
    p "New"
    @hora = Hora.new()
  end

  def create
    p "Create"
    @element = Hora.new( 
      tipo: params["hora"]["tipo"], 
      hora: params["hora"]["hora"] )
    if ( @element != nil ) && ( !@element.save )
      @element = nil
    end
    result(principal_path,@element)
  end

  def edit
    p "Edit"
    @element = Hora.find(params[:id]) rescue nil
  end

  def update
    p "Update"
    @element = Hora.find(params[:id]) rescue nil
    if ( @element != nil ) && ( !@element.update( 
      tipo: params["hora"]["tipo"], 
      hora: params["hora"]["hora"] ) )
      @element = nil
    end
    result(principal_path,@element)
  end

  def destroy
    p "Destroy"
    @element = Hora.find(params[:id]) rescue nil
    if ( @element != nil ) && ( !@element.destroy )
      @element = nil
    end
    result(principal_path,@element)
  end
end
