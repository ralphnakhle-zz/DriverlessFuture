
class AccidentClass {
  
  AccidentClass() {
  
  }
  
  //Method displaying accident 
  void displayAccident(int randomX, int randomY) {
  
    fill(255, 165, 0);
    int cone = 7;
    triangle(randomX-cone,randomY+cone,randomX+cone,randomY+cone,randomX,randomY-cone*2);
    ellipse(randomX,randomY+cone,cone*3,cone/1.5);
    fill(255);
        ellipse(randomX,randomY,cone*1.5,cone/2);

    //ellipse(randomX, randomY, 20, 20);
  }
}

