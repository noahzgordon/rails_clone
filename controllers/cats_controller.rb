class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:notice] = "Cat saved!"
      redirect_to cat_url(@cat)
    else
      flash[:error] = "Invalid cat!"
      render :new
    end
  end

  def show
    @cat = Cat.find(params[:cat_id])
    render :show
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end