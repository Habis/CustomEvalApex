# CustomEvalApex
Custom eval based on JS eval, but for apex

# How this works?

Based on the records generated in the metadata, you can calculate conditions writed in plain text, you pass as parameters a map containing the SObjects that needs to be replaces, and a Set of the metadata names to be calculated.

** Example (for massive calculation): **

1. Create a new metadata for customRule called TestMdt, fill the Expression field with: 1 && 2
2. Create 2 metadatas Rule conditions, associated with the customRule, fill the order with 1 or 2, this makes reference to the number in the Expression of the parent record
  3. 1 => Account.Name != 'Acme'
  4. 2 => Opportunity.StageName != 'Closed/Lost'
5. To execute the rules use the code below, fill the map with the keys you're going to use in the metadata

```
Map<String, Sobject> map_sobj = new Map<String, SObject>{'Account' => [SELECT Name FROM Account LIMIT 1],
'Opportunity' => [SELECT StageName FROM Opportunity LIMIT 1]};
CustomRuleMdtHandler.eval(new Set<String>{'TestMdt'}, map_sobj);
```

the method returns a map (TestMdt => true/false), the key developerName of the Custom Rule and value the result of the condition.

# Evaluate single condition, no mdt needed

For a single condition, you can just user CustomEval class, initialize a constructor with `(String condition, Map<String, Sobject> map_sobj)`

** Example (single condition): **
It's almost the same as MassEval

```
Map<String, Sobject> map_sobj = new Map<String, SObject>{'Account' => [SELECT Name FROM Account LIMIT 1],
'Opportunity' => [SELECT StageName FROM Opportunity LIMIT 1]};

 CustomEval ceval = new CustomEval('Account.Name != 'Acme', map_sobj);
 ceval.eval()
 ```
 
 eval() returns the result of the conditional
