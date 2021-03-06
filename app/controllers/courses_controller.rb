class CoursesController < ApplicationController
  def new
    @course = Course.new
  end

  def create
    # Make letters in course numbers upper case
    params[:course][:number] = params[:course][:number].upcase
    
    # Set the created_by value to the current user
    params[:course][:created_by] = current_user.id
    
    course = Course.new(params[:course])
    
    unless course.course_already_exists
      if course.save
        # Add the current user to the course
        course.users << current_user
      
        flash[:notice] = 'Course created!'
      else
        flash[:alert] = 'There was a problem creating the course'
      end
    else
      flash[:alert] = 'Course already exists'
    end
    
    redirect_to root_url
  end

  def destroy
    course = Course.find(params[:id])
    
    if course.destroy
      flash[:notice] = 'Course deleted'
    else
      flash[:alert] = 'There was a problem deleting the course'
    end
    
    redirect_to settings_path
  end
end
