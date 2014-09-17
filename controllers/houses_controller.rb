class HousesController < ControllerBase
  def create
    @house = House.new(params["house"])
    
    if @house.save
      flash[:notice] = "House saved!"
      redirect_to house_url(@house)
    else
      flash[:error] = "Invalid house!"
      render :new
    end
  end
  
  def show
    @house = House.find(params[:house_id])
    render :show
  end

  def new
    @house = House.new
    render :new
  end
  
  def index
    @houses = House.all
    render :index
  end
end