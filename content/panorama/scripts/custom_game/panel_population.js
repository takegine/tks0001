var popnow = 0
var population = 0

    function populationUp(table_name, key, data ){
        var ID = Players.GetLocalPlayer();
        //$.Msg( ID, ": ", "Table:", table_name, " changed: '", key, "' = ", data );
        if (ID == key){
              $("#PopExample").GetChild(0).text=data.popNow+"/"+data.popMax
        }
      
        
        //$.Msg("populationUp"," ",popnow," ",population)
    }

    function populationCreate(params) {
        popnow = params.Popnow
        population = params.Population
        $("#PopExample").GetChild(0).text=popnow+"/"+population
        
        $.Msg("populationUp",popnow,population)
    }



CustomNetTables.SubscribeNetTableListener( "Hero_Population", populationUp );
//GameEvents.Subscribe( "populationCreate", populationCreate)
//GameEvents.Subscribe( "populationUp", populationUp)
//GameEvents.Subscribe( "wujiang_shopUp", populationUp)
$("#PopExample").GetChild(0).test=popnow+"/"+population