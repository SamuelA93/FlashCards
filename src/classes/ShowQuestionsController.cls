public   with sharing class ShowQuestionsController {

	public static integer numberItems=5;
	public ShowQuestionsController() {
		
	}
	@RemoteAction
	public static list<Question__c> getQuestions(string word){
		list<Question__c> k = new list<Question__c>();
		k =Database.query('SELECT Id, Question__c, Help_link__r.Link__c ,(SELECT id, Option__r.Option__c, Correct__c FROM Answers__r) FROM Question__c WHERE Question__c LIKE \'%'+word+'%\' LIMIT '+numberItems);
		return k;
	}
	@RemoteAction
	public static string saveQuestion(questionSelected objQ, list<answerSelected> ansQ,list<string> deletelistA){
			system.debug('////////////////////////// 1'+objQ);
			system.debug('////////////////////////// 2'+ansQ);
			//system.debug('////////////////////////// 3'+opsQ);
			system.debug('////////////////////////// 4'+deletelistA);
			try{
				//Question__c qaux = new Question__c();
				//qaux = Database.query('SELECT Id, Question__c, Help_link__r.Link__c ,(SELECT id, Option__r.Option__c, Correct__c FROM Answers__r) FROM Question__c WHERE Question__c ='+objQ.id);
				
			} catch (ListException e) {
				
			} catch (Exception e) {
				
			} finally {
			
			}
			
		return 'nada';
	}
	class questionSelected{
		public string idq 		{get;set;}
  		public string q 		{get;set;}
  		public string operation {get;set;}
	
	}
	
	class answerSelected{
		public string ida		 {get;set;}
  		public string ido 		 {get;set;}
  		public string correct 	 {get;set;}	
  		public string operation	 {get;set;}
  		public optionSelected option	 {get;set;}
	}

	class optionSelected{
		public string ido 		 {get;set;}
  		public string option	 {get;set;}	 
  		public string operation	 {get;set;}
	}
}