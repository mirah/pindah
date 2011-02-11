import android.app.Activity

class HelloWorld < Activity
  def onCreate(state)
    super state
    setContentView R.layout.main
  end
end
