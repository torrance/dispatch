class ModerateController < ApplicationController
  check_authorization # Ensure cancan validation on every controller method

  def vote
    @content = Content.find(params[:id])
    authorize! :moderate, @content

    @vote = Vote.cast_vote(@content.id, current_user.id, params[:vote].to_i)

    if @vote.save
      redirect_to :back
    else
      redirect_to :back, :notice => "An error occurred moderating this content #{@content.errors.full_messages}"
    end
  end

  def hide
    @content = Content.find(params[:id])
    authorize! :moderate, @content

    if @content.hide(current_user, params[:hide])
      redirect_to :back
    else
      redirect_to :back, :notice => "An error occurred moderating this content #{@content.errors.full_messages}"
    end
  end
end