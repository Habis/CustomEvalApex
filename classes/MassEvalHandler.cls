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
		System.debug('MASSEVALHANDLER : ');
		String exprFinal = expression;
		CustomEval ceval = new CustomEval(map_values);
		Boolean evalRes = false;
		Integer lstSize = 0;

		for(String cond : lstConditions){
			ceval.condition = cond;
			evalRes = ceval.eval();
			System.debug('evalRes ' + evalRes);
			lstRes.add(evalRes);
			lstSize = lstRes.size();
			System.debug('MASSEVALHANDLER : evaular condición ' + lstSize + ' : ' + cond + ' resultado : ' + evalRes);
			exprFinal = exprFinal.replace(String.valueOf(lstSize), String.valueOf(evalRes));
		}
		
		ceval.condition = exprFinal;
		res = ceval.eval();

		System.debug('MASSEVALHANDLER :  evaular condición: ' + expression + ' Final lógica ' + exprFinal + ' resultado : ' + res);

		return res;
	}	


}
