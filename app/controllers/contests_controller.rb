class ContestsController < ApplicationController
  helper_method :survey, :participant

  # create a new attempt to this survey
  def new
    @participant ||= current_user
    @attempt = survey.attempts.new
    # build a number of possible answers equal to the number of options
    survey.questions.size.times { @attempt.answers.build }
  end

  # create a new attempt in this survey
  # an attempt needs to have a participant assigned
  def create
    @attempt = survey.attempts.new(params[:survey_attempt])
    # ensure that current user is assigned with this attempt
    @attempt.participant = participant
    if @attempt.valid? and @attempt.save
      redirect_to contests_path
    else
      render :action => :new
    end
  end

  def participant
    @participant ||= current_user
  end

  def survey
    @survey = Survey::Survey.find_by(id: params[:survey_id]) unless params[:survey_id].nil?
    @survey = Survey::Survey.find_by(id: params[:survey_attempt][:survey_id]) unless params[:survey_attempt][:survey_id].nil?
  end
end
