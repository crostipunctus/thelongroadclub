class NewsletterSubscriptionsController < ApplicationController
  def create
    subscription = NewsletterSubscription.find_or_initialize_by(email: params[:email].to_s.strip.downcase)
    subscription.assign_attributes(status: :active, source: params[:source].presence || "homepage")
    if subscription.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "You’re on the Weekend Brief list." }
        format.json { render json: { subscribed: true }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: subscription.errors.full_messages.to_sentence }
        format.json { render json: { errors: subscription.errors.to_hash }, status: :unprocessable_entity }
      end
    end
  end
end
