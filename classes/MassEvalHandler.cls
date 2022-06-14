public with sharing class MassEvalHandler {

	
	public String expression{ get; set; }
	Boolean res;
	public List<String> lstConditions{ get; set;}
	Map<String, SObject> map_values{get;set;}
	List<Boolean> lstRes;


	public MassEvalHandler(Map<String, SObject> map_values){
		this.map_values = map_values;
		this.lstRes = new List<Boolean>();
	}

	public MassEvalHandler(String expression, List<String> lstCondition,Map<String, SObject> map_values){
		this.expression = expression;
		this.lstConditions = lstCondition;
		this.map_values = map_values;
		this.lstRes = new List<Boolean>();
	}

	public Boolean eval(){
		String exprFinal = expression;
		CustomEval ceval = new CustomEval(map_values);
		Boolean evalRes = false;
		Integer lstSize = 0;
		lstRes.clear();

		for(String cond : lstConditions){
			ceval.condition = cond;
			evalRes = ceval.eval();

			lstRes.add(evalRes);
			lstSize = lstRes.size();
			System.debug('MASSEVALHANDLER : evaular condición ' + lstSize + ' : ' + cond + ' => ' + evalRes);
			exprFinal = exprFinal.replace(String.valueOf(lstSize), String.valueOf(evalRes));
		}
		
		ceval.condition = exprFinal;
		res = ceval.eval();

		System.debug('MASSEVALHANDLER :  evaular lógica: ' + expression + ' EXPR FINAL: ' + exprFinal  + ' =>  ' + res);

		return res;
	}	


}