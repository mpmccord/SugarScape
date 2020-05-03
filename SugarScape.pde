SugarGrid myGrid;
int sgWidth;
Graph numGraph;
Graph ageAvgGraph;
Graph wealthGraph;
Graph ageGraph;
SocialNetwork socialNetwork;
Random rand;
char pkey;
HashMap<Character, Integer[]> childOnset;
HashMap<Character, Integer[]> climactOnset;
void setup() { 
  /* Testing */
  (new SquareTester()).test();
  (new AgentTester()).test();
  (new SugarGridTester()).test();  
  (new GrowbackRuleTester()).test();
  (new StackTester()).test();
  (new QueueTester()).test();
  (new ReplacementRuleTester()).test();
  (new SeasonalGrowbackRuleTester()).test();
  Integer[] ages = {13, 27};
  childOnset = new HashMap<Character, Integer[]>();
  climactOnset = new HashMap<Character, Integer[]>();
  childOnset.put('x', ages);
  ages[0] = 0;
  ages[1] = 40;
  childOnset.put('y', ages);
  ages[0] = 0;
  ages[1] = 70;
  climactOnset.put('x', ages);
  climactOnset.put('y', ages);
  size(1400, 1000);
  sgWidth = 1400;
  background(128);

  int numAgents = 20;
  int minMetabolism = 3;
  int maxMetabolism = 6;
  int minVision = 3;
  int maxVision = 6;
  int minInitialSugar = 5;
  int maxInitialSugar = 10;
  MovementRule mr = new PollutionMovementRule();
  AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
    minInitialSugar, maxInitialSugar, mr);

  int alpha = 2;
  int beta = 1;
  int gamma = 1;
  int equator = 1;
  int numSquares = 4; 
  SeasonalGrowbackRule sgr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);

  myGrid = new SugarGrid(50, 50, 20, sgr);
  myGrid.addSugarBlob(15, 15, 2, 8);
  myGrid.addSugarBlob(35, 35, 2, 8);
  for (int i = 0; i < numAgents; i++) {
    Agent a = af.makeAgent();
    myGrid.addAgentAtRandom(a);
  }

  numGraph = new NumberOfAgentsTimeSeriesGraph(sgWidth-350, 50, 300, 150);
  ageAvgGraph = new AverageAgentAgeTimeSeriesGraph(sgWidth-350, 250, 300, 150, 1000);
  wealthGraph = new SortedAgentWealthGraph(sgWidth-350, 450, 300, 150);
  //ageGraph = new AgeCDFGraph(sgWidth-350, 650, 300, 150);

  rand = new Random();

  frameRate(5);
}
void keyPressed() {
  pkey = key;
}
void draw() {  
  println(pkey);
  numGraph.update(myGrid);
  ageAvgGraph.update(myGrid);
  wealthGraph.update(myGrid);
  //ageGraph.update(myGrid);
  myGrid.update();
  //background(255);
  socialNetwork = new SocialNetwork(myGrid);
  // Display a random path in the social network
  ArrayList<Agent> agents = myGrid.getAgents();
  Agent randomAgent1 = agents.get(rand.nextInt(agents.size()));
  Agent randomAgent2 = agents.get(rand.nextInt(agents.size()));
  List<Agent> path = socialNetwork.bacon(randomAgent1, randomAgent2);
  int[] blue = {0, 0, 255};
  int[] diff = {0, 255, -255}; // destination: green
  int[] magenta = {255, 0, 255}; // in case of collision
  for (Agent a : agents) {
    a.setColors(pkey, childOnset, climactOnset, myGrid);
  }
  Square s1 = randomAgent1.getSquare();
  //println("Blue agent: ", s1.getX() + ", " + s1.getY());
  Square s2 = randomAgent2.getSquare();
  //println("Green agent: ", s2.getX() + ", " + s2.getY());
  if (randomAgent1 == randomAgent2) {
    randomAgent2.setColors(pkey, childOnset, climactOnset, myGrid);
  } else {
    randomAgent1.setColors(pkey, childOnset, climactOnset, myGrid);
    if (path != null) {
      path.remove(0);
      int steps = path.size();
      float step = 1.0;
      for (Agent a : path) {
        a.setFillColor(blue[0] + (int)(step*diff[0]/steps), 
          blue[1] + (int)(step*diff[1]/steps), 
          blue[2] + (int)(step*diff[2]/steps));
        step += 1.0;
      }
    } else {
      randomAgent2.setFillColor(blue[0]+diff[0], blue[1]+diff[1], blue[2]+diff[2]);
    }
  }
  myGrid.display();
  for (Agent a : agents) {
    a.setFillColor(0, 0, 0);
  }
}
