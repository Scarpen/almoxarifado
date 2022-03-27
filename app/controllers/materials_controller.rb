class MaterialsController < ApplicationController

  include MaterialsHelper

  layout "dashboard"

  before_action :set_paper_trail_whodunnit
  before_action :authorize

  skip_before_action :verify_authenticity_token, only: :updateQuantity
  def index
    @materials = Material.all
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    @material.quantity = 0
    @material.status = 0
    respond_to do |format|
      if @material.save
          format.html { redirect_to materials_path, notice: 'Material criado com sucesso.'}
      else
          format.html { redirect_to materials_path, notice: 'Já existe um material com esse nome.'}
      end
    end
  end

  def show
    @material = Material.find(params[:id])
    @material_log = ""
    @material.versions.reverse.each do |v|
      log = log(v)
      @material_log << log[:str] unless log.nil?
    end
  end

  def destroy
    @material = Material.find(params[:id])
    
    respond_to do |format|
      if can_destroy?(@material)
        @material.destroy
        format.html { redirect_to materials_path, notice: 'Material deletado com sucesso.'}
      else
        format.html { redirect_to materials_path, notice: 'Você não pode deletar um material que ja possui movimentação.'}
      end
    end

  end

  def activity_log
    versions = PaperTrail::Version.where(item_type: "Material").order(:created_at => :desc)
    @materials_log = ""
    versions.each do |v|
      if v.event == 'update'
        log = log(v)
        @materials_log << log[:str] unless log.nil? || log[:op] != 'qnt'
      end
    end

  end

  def updateName
    material = Material.find(params[:material])
    material.name = params[:name]
    if material.save
            render :json => {
        name: "#{material.name}",
        status: "success",
        notice: "Nome atualizado com sucesso."
      } 
    else
      render :json => {
        status: "failed",
        notice: "Não foi possivel alterar o nome."
      } 
    end
  end

  def updateQuantity
    material = Material.find(params[:material])
    quantity = params[:quantity].to_i
    operation = params[:operation]

    if quantity <= 0 || !quantity.is_a?(Integer)
      render :json => {
          status: "failed",
          notice: "Apenas valores inteiro acima de 0."
        } 
    else
      if operation == "1"
        material.quantity += quantity
      elsif operation == "2"
        r = Range.new('08:00', '18:00')
        shop_closed = Date.today.on_weekend? || !r.include?(Time.zone.now.strftime('%R'))
        material.quantity -= quantity
      end
      if material.quantity < 0
        render :json => {
          status: "failed",
          notice: "O estoque do produto não pode ficar negativo."
        } 
      elsif shop_closed
        render :json => {
          status: "failed",
          notice: "Só é possivel a retirada do material nos dias úteis entre as 9:00 e 18:00."
        } 
      else
        material.status = 1
        material.save
        render :json => {
          quantity: "#{material.quantity}",
          status: "success",
          notice: "Estoque atualizado com sucesso."
        } 
      end
    end
  end

  private
  def material_params
    params.require(:material).permit(:name)
  end



end
