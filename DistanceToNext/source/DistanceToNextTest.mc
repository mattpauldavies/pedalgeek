import Toybox.Activity;
import Toybox.Test;
import Toybox.Time;

class MockActivityInfoNextPoint extends Activity.Info {
  var distanceToNextPoint = 200;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function formattedDistanceM(logger) {
    logger.debug("Return meters formatted distance to next point");
    var view = new DistanceToNextView();
    var info = new MockActivityInfoNextPoint();
    var value = view.compute(info);
    Test.assertEqual(value, "200 m");
    return true;
}

class MockActivityInfoKmNextPoint extends Activity.Info {
  var distanceToNextPoint = 2292;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function formattedDistanceKm(logger) {
    logger.debug("Return kilometers formatted distance to next point");
    var view = new DistanceToNextView();
    var info = new MockActivityInfoKmNextPoint();
    var value = view.compute(info);
    Test.assertEqual(value, "2.29 km");
    return true;
}

class MockActivityInfoDistance extends Activity.Info {
  var distanceToNextPoint = null;
  var distanceToDestination = 6500;

  function initialize() {
    Activity.Info.initialize();
  }
}

(:test)
function formattedDistance(logger) {
    logger.debug("Return formatted destination distance if next point is null");
    var view = new DistanceToNextView();
    var info = new MockActivityInfoDistance();
    var value = view.compute(info);
    Test.assertEqual(value, "6.50 km");
    return true;
}
