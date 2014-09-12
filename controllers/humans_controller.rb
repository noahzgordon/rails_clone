class HumansController < ControllerBase
  def create
    @human = Human.new(params["human"])
    
    if @human.save
      flash[:notice] = "Human saved!"
      redirect_to human_url(@human)
    else
      flash[:error] = "Invalid human!"
      render :new
    end
  end
  
  def show
    @human = Human.find(params[:human_id])
    render :show
  end

  def new
    @human = Human.new
    render :new
  end
  
  def index
    @humans = Human.all
    render :index
  end
end