let searchInProgress = false

$(document).ready(()=>{
    $(".full-screen").hide()
    $(".kilepes").click(()=>{
        $.post(`https://${GetParentResourceName()}/close`)
    })

    $(".search_icon").click(()=>{
        if(!searchInProgress) {
            const inputVal = $("#search-input-id").val()
            if(inputVal!==""){
                searchInProgress = true
                $.post(`https://${GetParentResourceName()}/search`,JSON.stringify({input:inputVal}),(data)=>{
    
                    var promise = new Promise((resolve,reject)=>{
                        if(data===null){
                            $(".searchbar").effect("shake",{times:3,distance:10},1000)
                            setTimeout(resolve, 1000);
                        }
                        else if(data!==null){
                            const wasBg = $(`*[data-sectorid=${data}]`).css("background")
                            $('#main-table').scrollTop($(`*[data-sectorid=${data}]`).offset().top)
                            $(`*[data-sectorid=${data}]`).animate({
                                backgroundColor:"#008000"
                            },500,()=>{
                                setTimeout(() => {
                                    $(`*[data-sectorid=${data}]`).animate({
                                        backgroundColor:wasBg
                                    },500,()=>{
                                        resolve()
                                    })
                                }, 1500);
                            })
                        }
                    })
    
                    Promise.all([promise]).then(()=>{
                        searchInProgress = false
                    })
                })
            }
        }
    })

    window.addEventListener("message",(event)=>{
        const data = event.data 

        if(data.exitButton){
            exitButtonId = data.exitButton
        }

        if(data.show===true){
            $(".full-screen").show()
            $("#main-table").scrollTop(0)
            $("#search-input-id").val("")
        } else if(data.show===false){
            $(".full-screen").hide()
        }

        if(data.loadUi!==undefined){
            $("#main-table").html('<tr><th class="elso"><i class="fa-solid fa-server"></i> Sector Name</th><th class="elso"><i class="fa-solid fa-users"></i> Player Count</th><th class="elso"></th></tr>')

            for(let i = 0; i!=data.loadUi.length;i++){
                const current = data.loadUi[i]

                const SectorName = current.Name
                const SectorPlayers = (current.MaxPlayer==-1) ? current.PlayerNames.length : current.PlayerNames.length +"/"+current.MaxPlayer
                const InteractionButton = (current.PlayerNames.includes(data.selfName)) ? 
                    '<td id="interaction-button"> <div class="interaction-container interaction-container-joined"> <i class="fa-solid fa-location-dot"> </i> JOINED </div> </td>' : 
                    (current.MaxPlayer==-1 || current.PlayerNames.length<current.MaxPlayer) ? 
                    '<td id="interaction-button"> <div class="interaction-container interaction-container-join"> <i class="fa-solid fa-play"></i> JOIN </div> </td>' : 
                    '<td id="interaction-button"> <div class="interaction-container interaction-container-full"> <i class="fa-regular fa-circle-xmark"></i> FULL </div> </td>'


                const newRow = $(`<tr class="sector-row" data-sectorid=${current.Id}> <td>${SectorName}</td> <td>${SectorPlayers}</td>${InteractionButton}</tr>`).appendTo("#main-table")
                $(newRow).find("#interaction-button").click(()=>{
                    if((current.MaxPlayer == -1 || current.PlayerNames.length<current.MaxPlayer) && !current.PlayerNames.includes(data.selfName)){
                        $.post(`https://${GetParentResourceName()}/changedSector`,JSON.stringify({id:current.Id}))
                    }
                })
            }
        }
    })
})