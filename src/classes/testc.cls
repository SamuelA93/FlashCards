public class testc {
    public home myhome {get;set;}
    public testc(){
		myhome = new home();
        myhome.haslight=false;
    }
    public void nada(){
        
    }
    class home{
        public boolean hasLight{get;set;}
        public home(){
            
        }
    }
}