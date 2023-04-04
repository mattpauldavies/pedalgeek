import Toybox.Activity;
import Toybox.Test;
import Toybox.Time;

class MockActivityInfoNotStarted extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 0;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnZeroIfNotStarted(logger) {
    logger.debug("Return zero if not started");
    var view = new MovingPercentageView();
    var info = new MockActivityInfoNotStarted();
    var value = view.compute(info);
    Test.assertEqual(value, "0%");
    return true;
}

class MockActivityInfoMoving extends Activity.Info {
  var currentSpeed = 10;
  var elapsedTime = 10000;

  function initialize() {
    Activity.Info.initialize();
  }
}

class MockMovingPercentageView extends MovingPercentageView {
  function initialize() {
    MovingPercentageView.initialize();
    self.totalStopped = 5000;
  }
}

(:test)
function returnLastIfMoving(logger) {
    logger.debug("Return last percentage if moving");
    var view = new MockMovingPercentageView();
    var info = new MockActivityInfoMoving();
    var value = view.compute(info);
    Test.assertEqual(value, "50%");
    return true;
}

class MockActivityInfoStopped extends Activity.Info {
  var currentSpeed = 0;
  var elapsedTime = 20000;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function returnPercentageStopped(logger) {
    logger.debug("Return last percentage if moving");
    var view = new MockMovingPercentageView();
    var info = new MockActivityInfoStopped();
    var value = view.compute(info);
    Test.assertEqual(value, "75%");
    return true;
}
