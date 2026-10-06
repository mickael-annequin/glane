class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: %i[edit update move]

  def index
    @categories = Category.ordered
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "Catégorie « #{@category.name} » ajoutée."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Catégorie « #{@category.name} » modifiée."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def move
    @category.move(params[:direction])
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :hidden)
  end
end
