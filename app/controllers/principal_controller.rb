class PrincipalController < ApplicationController
  
  def dia_igual(fecha1,fecha2)
    return fecha1.day==fecha2.day && fecha1.month==fecha2.month && fecha1.year==fecha2.year
  end

  def es_hoy(fecha)
    hoy = DateTime.now
    return fecha.day==hoy.day && fecha.month==hoy.month && fecha.year==hoy.year
  end

  def index
  	@hora = Hora.new

    hoy = DateTime.now

    @suma = 0
    @suma_hoy = 0

    ultimo_dia=nil
    @dias=0

    comienzo = nil
    comienzo_hoy = nil


    horas = Hora.where("extract(month FROM hora)::int=#{hoy.month} AND extract(year FROM hora)::int=#{hoy.year}").order(hora: :asc)
    horas.each do |h|

      if ultimo_dia == nil
        ultimo_dia=h.hora
        @dias = 1
      elsif !dia_igual(ultimo_dia,h.hora)
        @dias = @dias+1
        ultimo_dia = h.hora
      end


      if (h.tipo==1)
        if ( comienzo == nil )
          comienzo = h.hora
        end
        if ( es_hoy(h.hora) && comienzo_hoy == nil )
          comienzo_hoy = h.hora
        end
      elsif (h.tipo==2)
        if comienzo != nil 
          @suma = @suma + (h.hora-comienzo).to_i
          comienzo=nil
        end
        if ( es_hoy(h.hora) && comienzo_hoy != nil )
          @suma_hoy = @suma_hoy + (h.hora-comienzo_hoy).to_i
          comienzo_hoy=nil
        end
      end
    end

    if comienzo != nil
        @suma = @suma + (DateTime.now-3.hours).to_i - (comienzo-0.hours).to_i
    end
    if comienzo_hoy != nil
        @suma_hoy = @suma_hoy + (DateTime.now-3.hours).to_i - (comienzo_hoy-0.hours).to_i
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
    @element = Hora.find(params[:id]) rescue nil
    result(pedidos_path,@element)
  end

  def new
    p "New"
    @element = Hora.new()
  end

  def create
    p "Create"
    @element = Hora.new( 
      tipo: params["hora"]["tipo"], 
      hora: params["hora"]["hora"] )
    if ( @element != nil ) && ( !@element.save )
      @element = nil
    end
    result(root_path,@element)
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
