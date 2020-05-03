import java.util.Map;
public class FertilityRule {
  Map<Character, Integer[]> childbearingOnset;
  Map<Character, Integer[]> climactericOnset;
  private HashMap<Agent, Integer[]> agentsFertility;
   public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character,Integer[]> climactericOnset) {
     this.childbearingOnset = childbearingOnset;
     this.climactericOnset = climactericOnset;
     agentsFertility = new HashMap<Agent, Integer[]>();
   }
   public boolean isFertile(Agent a) {
     Random rand = new Random();
     if (a == null || !a.isAlive()) {
       childbearingOnset.remove(a);
       climactericOnset.remove(a);
       return false;
     }
     if (agentsFertility.get(a) != null) {
       return a.getAge() >= agentsFertility.get(a)[0] && a.getAge() <= agentsFertility.get(a)[1];
     }
     Integer[] ages = new Integer[10];
     assert(childbearingOnset.containsKey('x'));
     assert(childbearingOnset.containsKey('y'));
     int max = childbearingOnset.get(a.getSex())[1];
     int min = childbearingOnset.get(a.getSex())[0];
     ages[0] = rand.nextInt(max - min) + min;
     max = climactericOnset.get(a.getSex())[1];
     min = climactericOnset.get(a.getSex())[0];
     ages[1] = rand.nextInt(max - min) + min;
     agentsFertility.put(a, ages);
     return a.getAge() >= agentsFertility.get(a)[0] && a.getAge() <= agentsFertility.get(a)[1];
   }
   public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {
     if (!isFertile(a) || !isFertile(b)) {
       return false;
     }
     if (a.getSex() == b.getSex()) {
       return false;
     }
     for (Square s : local)
       if (s.equals(b.getSquare())) {
         return true;
       }
     return false;
   }
   public Agent breed(Agent a, Agent b, LinkedList<Square> alocal, LinkedList<Square> blocal) {
     if (!canBreed(a, b, alocal) && !canBreed(b, a, blocal))
       return null;
     Random rand = new Random();
     int metabolism = 0;
     int vision = 0;
     char sex = 0;
     if (rand.nextFloat() < 0.5)
       metabolism = a.getMetabolism();
     else
       metabolism = b.getMetabolism();
       
     if (rand.nextFloat() < 0.5)
       vision = a.getVision();
     else
       vision = b.getVision();
     
     if (rand.nextFloat() < 0.5)
       sex = 'x';
     else
       sex = 'y';
     Agent child = new Agent(metabolism, vision, 0, a.getMovementRule(), sex);
     a.gift(child, int(0.5 * a.getSugarLevel()));
     b.gift(child, int(0.5 * b.getSugarLevel()));
     child.nurture(a, b);
     Square s;
     if (rand.nextFloat() < 0.5) {
       s = findRandom(alocal);
       if (s == null) {
         s = findRandom(blocal);
         if (s == null)
           return null;
       }
     }
     else {
       s = findRandom(blocal);
       if (s == null)
         s = findRandom(alocal);
       if (s == null)
         return null;
     }
     
     
     return child;
   }
   private Square findRandom(LinkedList<Square> squares) {
     for (int i = 0; i < squares.size(); i++) {
       int index = rand.nextInt(squares.size());
       if (squares.get(index).getAgent() == null)
         return squares.get(index);
     }
     return null;
   }
}
public class FertilityTester {
  public void test() {
    SugarGrid g = new SugarGrid(100, 100, 10, new GrowbackRule(5));
    HashMap<Character, Integer[]> childYears = new HashMap<Character, Integer[]>();
    Integer[] years = new Integer[2];
    years[0] = 10;
    years[1] = 15;
    childYears.put('x', years);
    years[0] = 5;
    years[1] = 10;
    childYears.put('y', years);
    HashMap<Character, Integer[]> endYears = new HashMap<Character, Integer[]>();
    years = new Integer[2];
    years[0] = 20;
    years[1] = 25;
    endYears.put('y', years);
    
    years[0] = 25;
    years[1] = 30;
    endYears.put('x', years);
    
    Agent a = new Agent(5, 8, 10, new SugarSeekingMovementRule(), 'x');
    Agent b = new Agent(5, 8, 10, new SugarSeekingMovementRule(), 'y');
    g.getRandomUnoccupiedSquare().setAgent(a);
    g.getRandomUnoccupiedSquare().setAgent(b);
    
    FertilityRule fr = new FertilityRule(childYears, endYears);
    println(fr.isFertile(a) + " " + fr.isFertile(b));
    Agent child = fr.breed(a, b, g.generateVision(a.getSquare().getX(), a.getSquare().getY(), a.getVision()), 
    g.generateVision(b.getSquare().getX(), b.getSquare().getY(), a.getVision()));
  }
}
