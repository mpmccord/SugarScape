import java.util.LinkedList;
import java.util.Collections;

interface MovementRule {
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public SugarSeekingMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    for (Square s : neighborhood) {
      if (s.getSugar() > retval.getSugar() ||
          (s.getSugar() == retval.getSugar() && 
           g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle)
          )
         ) {
        retval = s;
      } 
    }
    return retval;
  }
}

class PollutionMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public PollutionMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    boolean bestSquareHasNoPollution = (retval.getPollution() == 0);
    for (Square s : neighborhood) {
      boolean newSquareCloser = (g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle));
      if (s.getPollution() == 0) {
        if (!bestSquareHasNoPollution || s.getSugar() > retval.getSugar() ||
            (s.getSugar() == retval.getSugar() && newSquareCloser)
           ) {
          retval = s;
        }
      }
      else if (!bestSquareHasNoPollution) { 
        float newRatio = s.getSugar()*1.0/s.getPollution();
        float curRatio = retval.getSugar()*1.0/retval.getPollution();
        if (newRatio > curRatio || (newRatio == curRatio && newSquareCloser)) {
          retval = s;
        }
      }
    }
    return retval;
  }
}
class CombatMovementRule extends SugarSeekingMovementRule {
  int alpha;
  public CombatMovementRule(int alpha) {
    this.alpha = alpha;
  }
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square mid) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    LinkedList<Square> vulnerable = new LinkedList<Square>();
    for (Square s : neighborhood) {
      if (s.getAgent() == null) {
        continue;
      }
      if (sameCulture(s, mid) || hasMoreSugar(s, mid)) {
        println("Not valid");
        continue;
      }
      vulnerable.add(s);
    }
    
    println("Iteration 1");
    retval = super.move(neighborhood, g, mid);
    return retval;
  }
  private boolean hasMoreSugar(Square s, Square mid) {
    if (s.getAgent().getSugarLevel() > mid.getAgent().getSugarLevel())
      return true;
    return false;
  }
  private boolean sameCulture(Square s, Square mid) {
    Agent midAgent = mid.getAgent();
    for (int i = 0; i < s.getAgent().culture.length; i++) {
      if (!s.getAgent().culture[i] == midAgent.culture[i]) {
        return false;
      }
    }
    return true;
  }
  public void inVision(Square mid, LinkedList<Square> neighborhood, SugarGrid g) {
    LinkedList<Square> inVision = g.generateVision(mid.getX(), mid.getY(), mid.getAgent().getVision());
    for (Square s : inVision) {
      if (0 < 1) {
        print("True");
      }
    }
  }
}
class SugarSeekingMovementRuleTester {
  public void test() {
    SugarSeekingMovementRule mr = new SugarSeekingMovementRule();
    //stubbed
  }
}

class PollutionMovementRuleTester {
  public void test() {
    PollutionMovementRule mr = new PollutionMovementRule();
    //stubbed
  }
}
