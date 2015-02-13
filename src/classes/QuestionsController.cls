global with sharing class QuestionsController {
	
	public list<Question__c> listQuestions 	{get;set;}
	public list<questionsWrapp> listQuestionWrapp{get;set;}
    public integer questionItem {get;set;}
    public boolean ismulti {get;set;}
    public string idOption {get;set;}
    public integer step {get;set;}
    static list<questionsWrapp> listOfQuestions;
    
	public QuestionsController() {
		step = 1;
		questionItem = 0;
		idOption= '';
		listQuestions = new list<Question__c>([SELECT Id, Question__c, Help_link__r.Link__c ,(SELECT id, Option__r.Option__c, Correct__c FROM Answers__r) FROM Question__c LIMIT 60]);
		if(!listQuestions.isEmpty()){
			listQuestionWrapp = new list<questionsWrapp>();
			for(Question__c var :listQuestions){
				questionsWrapp aux = new questionsWrapp();
				aux.question = var.Question__c;
				aux.questionID = var.id;
				aux.helpLink = var.Help_link__r.Link__c;
				aux.ListOptions(var.Answers__r);
				listQuestionWrapp.add(aux);
			}
		}
		
		//isMulti();
	}
	public void next(){
		/*if(!ismulti){
			uniOptionset();
		}*/
		if( questionItem < listQuestionWrapp.size() -1){
			questionItem++;
			/*isMulti();*/
		}
		idOption = listQuestionWrapp.get(questionItem).optionIFoneOption;
	}
	public void selectSet(){
		for(optionsWrapp var :listQuestionWrapp.get(questionItem).options){
			if(var.id.contains(idOption)){
				var.participantThink = true;
				listQuestionWrapp.get(questionItem).optionIFoneOption = idOption;
			}else{
				var.participantThink = false;
			}
		}
	}
	public void uniOptionset(){
		for(optionsWrapp var :listQuestionWrapp.get(questionItem).options){
				if((idOption!=null)&&(var.id.contains(idOption))){
					listQuestionWrapp.get(questionItem).optionIFoneOption = idOption;
					var.participantThink = true;
				}
			}
	}
	public void BackCheck(){
		step=3;
	}
	public void back(){
		
		if( questionItem > 0 ){
			questionItem--;
		}
		idOption = listQuestionWrapp.get(questionItem).optionIFoneOption;
		/*isMulti();
		if(!ismulti){
			cleanOption();
		}*/
	}
	public void isMulti(){
		integer i = 0;
		ismulti = false;
		for(optionsWrapp var :listQuestionWrapp.get(questionItem).options){
			if(var.isCorrect){
				if(i>0){
					ismulti = true;
				}
				i++;
			}
		} 
	}
	
	public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(optionsWrapp var :listQuestionWrapp.get(questionItem).options){
        	options.add(new SelectOption(var.id,'  '+var.option)); 
        }
        return options; 
    }
    
	class questionsWrapp{
		
		public String  questionID			{get;set;}
		public String  question 			{get;set;}
		public String  helpLink 			{get;set;}
		public String  optionIFoneOption    {get;set;}
		public boolean reviewQuestion 		{get;set;}
		public boolean answeredRight 		{get;set;}
		public list<optionsWrapp> options   {get;set;}
		
		public questionsWrapp(){
			options =  new list<optionsWrapp>();
			reviewQuestion = false;
			answeredRight =true;
			optionIFoneOption = '';
		}
		
		public void ListOptions( Answer__c[] ans){
			for(Answer__c var :ans){
				optionsWrapp auxOp 	= new optionsWrapp();
				auxOp.option 		= var.Option__r.Option__c;
				auxOp.isCorrect 	= var.Correct__c;
				auxOp.id 			= var.id;
				options.add(auxOp);
			}
		} 
	}
	class optionsWrapp{
		public String  id	 				{get;set;}
		public String  option 				{get;set;}
		public boolean isCorrect			{get;set;}
		public boolean participantThink 	{get;set;}
		
		public optionsWrapp(){
			participantThink = false;
		}
    }
    
    public void editQuestion(){
    	step = 1;
    	listQuestionWrapp.get(questionItem).reviewQuestion=false;
    	idOption = listQuestionWrapp.get(questionItem).optionIFoneOption;
    	/*isMulti();
		if(!ismulti){
			cleanOption();
		}*/
    }
    
    public void cleanOption(){
		for(optionsWrapp var :listQuestionWrapp.get(questionItem).options){
			if(var.id.contains(listQuestionWrapp.get(questionItem).optionIFoneOption)){
				var.participantThink = false;
			}
		}
		listQuestionWrapp.get(questionItem).optionIFoneOption = '';
    }
    
    public void viewAnswer(){
    	step = 4;
    }
    
    public void checkAnswers(){
    	for(questionsWrapp  var :listQuestionWrapp){
    		for(optionsWrapp ops :var.options){
    			if(ops.isCorrect != ops.participantThink){
    				var.answeredRight = false;
    			}
    		}
    	}
        step = 3;
    }
    @RemoteAction
    global static integer sendManyQuestions(){
    	return [SELECT Id, Question__c, Help_link__r.Link__c ,(SELECT id, Option__r.Option__c, Correct__c FROM Answers__r) FROM Question__c LIMIT 60].size();
 		  
    }
    public void fcontinue(){
    	if(step==1){
    		/*if(!ismulti){
				uniOptionset();
			}*/
    	}
    	step =2;
    }
}