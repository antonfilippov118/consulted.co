class Users::HistoryController < Users::BaseController
  def show
    title! 'Your calls'
  end

  def offered
    @calls = Call.to(@user).to_a
    render 'calls'
  end

  def requested
    @calls = Call.by(@user).to_a
    render 'calls'
  end
end
