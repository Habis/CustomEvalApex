public with sharing class CustomRuleMdtHandler {

	public static Map<String, Boolean> eval(Set<String> set_customRuleMdts, Map<String, SObject> map_values) {
		
		Map<String, Boolean> map_res = new Map<String, Boolean>();
		
		MassEvalHandler massEvalHand = new MassEvalHandler(map_values);
		List<String> lstConditions = new List<String>();
		for(CustomRule__mdt rules : [SELECT DeveloperName, Expression__c, (SELECT DeveloperName, Expression__c FROM RuleConditions__r ORDER BY Order__c) FROM CustomRule__mdt WHERE DeveloperName = :set_customRuleMdts]){
			System.debug('Eval ' + rules.DeveloperName);
			if(!lstConditions.isEmpty())lstConditions.clear();
			for(RuleCondition__mdt rulecond : rules.RuleConditions__r){
				lstConditions.add(rulecond.Expression__c);
			}
			System.debug('Expressions ' + rules.Expression__c);
			massEvalHand.expression = rules.Expression__c;
			massEvalHand.lstConditions = lstConditions;
			System.debug('Conditions ' + lstConditions);
			map_res.put(rules.DeveloperName, massEvalHand.eval());
		}
		return map_res;
    }
}
