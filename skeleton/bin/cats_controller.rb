class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:notice] = "Cat saved!"
      redirect_to cats_url
    else
      flash[:error] = "Invalid cat!"
      redirect_to new_cat_url
    end
  end

  def show
    @cat = Cat.all.find{ |cat| cat.id == params["cat_id"]}
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