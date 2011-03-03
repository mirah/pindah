package <%= package %>

import android.app.Activity

class INITIAL_ACTIVITY < Activity
  def onCreate(state)
    super state
    setContentView R.layout.main
  end
end
