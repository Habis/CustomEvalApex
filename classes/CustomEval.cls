public without sharing class CustomEval {
    
	public Map<String, SObject> map_values{ get; set; }
	String finalCondition = '';
	List<String> lstCondition;
	Boolean res = false;

	private final String AND_x = '\\&\\&';
	private final String OR_x = '\\|\\|';
	private final String EQ = '==';
	private final String NOTEQ = '!=';
	private final String OPEN_P = '(';
	private final String CLOSE_P = ')';
	private final String GRTEQ = '>=';
	private final String GRT = '>';
	private final String MINEQ = '<=';
	private final String MIN = '<';

	private final Set<String> SET_OPERATORS = new Set<String>{AND_x, OR_x, EQ, NOTEQ, OPEN_P, CLOSE_P,GRTEQ,GRT,MINEQ,MIN};
	
	public String condition{
		get { return condition; }
		set {
			System.debug('setting condition');
			this.finalCondition = value;
			this.lstCondition = value.split('\\s+(?=([^"]*"[^"]*")*[^"]*$)');
			System.debug(lstCondition);

			condition = value; 
		}
	}
	public CustomEval(){

	}

	public CustomEval(String condition, Map<String, SObject> map_values){

		this.condition = condition;
		this.map_values = map_values;
	}
	
	public CustomEval(Map<String, SObject> map_values){
		this.map_values = map_values;
	}

	public Boolean eval(){
		formatFinalCondition();
		return this.res;
	}

	private void formatFinalCondition(){
		System.debug('lstCondition ' + lstCondition);
		List<String> auxListCond = lstCondition.clone();
		Integer indexOfWord = 0;
		for(String word : lstCondition){
		
			if(SET_OPERATORS.contains(word))continue;

			//System.debug('word.contains(.) && word.containsNone(")' + word.contains('.') && word.containsNone('"'));
			if(word.contains('.') && word.containsNone('"')){
				System.debug('word ' + word);
				List<String> lstObject = word.split('\\.');
				System.debug('lstObject' + lstObject);
				System.debug('lstCondition.get(indexOfWord+1) ' + lstCondition.get(indexOfWord+1));
				String operator = lstCondition.get(indexOfWord+1);
				String val = lstCondition.get(indexOfWord+2);
				String buildStr = word + ' ' + operator + ' ' + val;
				System.debug(' buildStr ' +  buildStr + ' indexOfWord ' + indexOfWord);

				if(map_values.containsKey(lstObject[0])){
					String sobjval = String.valueOf(map_values.get(lstObject[0]).get(lstObject[1]));
					System.debug('formatFinalCondition REPLACE  ' + buildStr + ' POR   ' +sobjval + ' COND: ' +finalCondition);
					finalCondition = finalCondition.replace(buildStr, String.valueOf(evaluateStr(sobjval, lstCondition.get(indexOfWord+1), (val.contains('"') ? val.substring( 1, val.length() - 1 ) : val))));
				}else{
					finalCondition = finalCondition.replace(buildStr, 'false');
				}
				System.debug('calculating finalCondition' + finalCondition);
				indexOfWord+=4; 

			}
		
		}
		System.debug('finalCondition: ' + finalCondition);
		evaluateFinalStr();
	}

	private void evaluateFinalStr(){
		List<String> splittedFinalCond = finalCondition.split(' ');
		
		System.debug('splittedFinalCond ' + splittedFinalCond + ' contains openP ' + finalCondition.contains(OPEN_P));

		if(!finalCondition.contains(OPEN_P)){
			this.res = evaluateBool(finalCondition);
			return;
		}
		Integer indexOfOpenP = -1;
		Integer indexOfCloseP = -1;

		for(String cond : splittedFinalCond){
			if(cond == OPEN_P){
				indexOfOpenP = splittedFinalCond.indexOf(cond);
				continue;
			}
			if(cond == CLOSE_P){
				indexOfCloseP = splittedFinalCond.indexOf(cond);
				break;
			}
		}
        System.debug(indexOfOpenP + ' - ' + indexOfCloseP);

		String replaceBooleans = getReplaceText(splittedFinalCond, indexOfOpenP, indexOfCloseP);
		System.debug('replaceBooleans ' + replaceBooleans);
        finalCondition = finalCondition.replace( OPEN_P + ' ' + replaceBooleans + ' ' + CLOSE_P, String.valueOf( evaluateBool(replaceBooleans) ) );
        System.debug(replaceBooleans);
        System.debug(finalCondition);
        System.debug('########');
        evaluateFinalStr();
	}

	private Boolean evaluateStr(String sobjval, String operator, String val){
		System.debug('METHOD evaluateStr ' + sobjval +  operator + val);
		switch on operator {
			when '=='{
				return sobjval == val;
			}
			when '!='{
				return sobjval != val;
			}
			when '<'{
				return sobjval < val;
			}
			when '>'{
				return sobjval > val;
			}
			when '<='{
				return sobjval <= val;
			}
			when '>='{
				return sobjval >= val;
			}
		}
		return false;
	}
    private Boolean evaluateBool(String expression){
		System.debug('evaluateBool ' + expression);
        Boolean result = false;
		System.debug('evaluateBool OR ' + expression.split(OR_x));
        for( String conj : expression.split(OR_x) ){

            Boolean b = true;
			System.debug('evaluateBool AND' + expression.split(AND_x));

            for( String single : conj.split(AND_x) ){
                b &= Boolean.valueOf(single.trim());
            }

            result |= b;
        }
		System.debug(result);
        return result;

    }
	private String getReplaceText(List<String> lstsplit, Integer indexopen, Integer indexclose){
		String ret = '';
		for(Integer i = indexopen +1 ; i < indexclose; i++){
			ret+=lstsplit[i] + ' ';
		}
		return ret.trim();
	}
}