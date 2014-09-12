class HumansController < ControllerBase
  def index
    @humans = Human.all
    render :index
  end
end