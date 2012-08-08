class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings

    # session[:ratings] = params[:ratings].nil
    session['rating_filter'] = params[:ratings] if(params[:commit]=="Refresh")

    @checked={}
    @all_ratings.each do |rating|
      @checked[rating] = !session['rating_filter'].nil? && session['rating_filter'].has_key?(rating)
    end

    filter = session['rating_filter'].nil? ? @all_ratings : session['rating_filter'].keys

    session[:sort] = params[:sort] || session[:sort]

    redirect_to movies_path(sort: session[:sort], ratings: session['rating_filter'], restful: true) unless params[:restful]

    @movies = case session[:sort]
      when "title" then
        @title_class="hilite"
        Movie.order("title").where(:rating => filter)
      when "release_date" then
        @release_date_class="hilite"
        Movie.order("release_date").where(:rating => filter)
      else  Movie.where(:rating => filter)
    end
         
  end
    
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def test
    @all_ratings= Movie.select(:rating).map(&:rating).uniq
  end  

end
