#!/bin/bash

LAST_ITEM_ID=0
LAST_SKIN_ID=0
LAST_RES_ID=0
LAST_REC_ID=0
LAST_POT_ID=0

PSQL="psql --username=postgres -c"

echo $($PSQL "drop database server")
echo $($PSQL "create database server")

PSQL="psql --username=postgres --dbname=server -t -c"

echo $($PSQL "\i data.sql")

W_TYPES_NUM=$($PSQL "SELECT COUNT(*) FROM weapon_type")
W_CLASSES_NUM=$($PSQL "SELECT COUNT(*) FROM weapon_class")
A_TYPES_NUM=$($PSQL "SELECT COUNT(*) FROM armor_type")
A_CLASSES_NUM=$($PSQL "SELECT COUNT(*) FROM armor_class")
SKINS_NUM=$($PSQL "SELECT COUNT(*) FROM skin")
PROPS_NUM=$($PSQL "SELECT COUNT(*) FROM property")
RAITY_TOTAL_NUM=$($PSQL "SELECT COUNT(*) FROM rarity")

function RANDINT {
    local MIN=$1
    local MAX=$2
    local NUM=$(((RANDOM % ( MAX - MIN + 1 ) + MIN)))
    echo $NUM
}
function RANDPERCENT {
    echo $(RANDINT 1 100)
}
function RANDSTR {
    local FILEPATH=$1
    echo $(shuf -n 1 $FILEPATH)
}
function GEN_ADJECTIVE {
    echo $(RANDSTR dataset/adjectives.txt)
}
function GEN_NOUN {
    echo $(RANDSTR dataset/nouns.txt)
}
function GEN_SURNAME {
    echo $(RANDSTR dataset/surnames.txt)
}
function GEN_USERNAME {
    echo $(GEN_SURNAME)
}
function GEN_NPC_NAME {
    local FIRST=$(GEN_SURNAME)
    local SECOND=$(GEN_SURNAME)
    echo ${FIRST^} ${SECOND^}
}
function GEN_ITEM_NAME {
    local ADJ=$(GEN_ADJECTIVE)
    local NOUN=$(GEN_NOUN)
    echo ${ADJ^} ${NOUN^}
}

TREAS_DESCR=("A fake item with no value" "A graceless decoration, valuable due to materials" "An useless but beautiful treasure item" "An item that unlocks magical potential of wearer" "A cursed item that grants the wearer immense power" "An ancient item with inexplicable properties")

TREAS_PERCENTAGE=(60 10 10 10 7 3)

function RANDELBYPERCENTAGE {
    local -n PERCENTAGE=$1
    local -n TARGETARR=$2
    local PERCENT=$(RANDPERCENT)
    local CURRENT=0 
    for i in ${!PERCENTAGE[@]}
    do
        CURRENT=$(($CURRENT+${PERCENTAGE[$i]}))
        if [ $PERCENT -le $CURRENT ]
        then 
            echo ${TARGETARR[$i]} 
            break
        fi
    done
}
function GEN_RAR_ID {
    local R_PER=(70 20 10)
    local DATA=($(seq 1 $RAITY_TOTAL_NUM))
    echo $(RANDELBYPERCENTAGE R_PER DATA)    
}
function GEN_RGB {
    local LETTERS=(A B C D E F)
    local RGB=""
    for (( i = 1; i <= 6; i++ ))
        do
        if [ $(RANDINT 0 1) -eq 1 ]
            then
            local CYMBOL=${LETTERS[ $RANDOM % ${#LETTERS[@]} ]}
            else
            local CYMBOL=$(RANDINT 0 9)
        fi
        RGB="$RGB$CYMBOL"
    done
    echo $RGB
}
function GEN_SKIN {
    echo "('$(GEN_ITEM_NAME)', '$(GEN_RGB)', '$(GEN_RGB)')"
}
function GEN_SKIN_ID {
    echo "$(RANDINT 1 $LAST_SKIN_ID)"
}
function GEN_W_T_ID {
    echo "$(RANDINT 1 $W_TYPES_NUM)"
}
function GEN_W_C_ID {
    echo "$(RANDINT 1 $W_CLASSES_NUM)"
}
function GEN_A_T_ID {
    echo "$(RANDINT 1 $A_TYPES_NUM)"
}
function GEN_A_C_ID {
    echo "$(RANDINT 1 $A_CLASSES_NUM)"
}

W_DESCRS=("This sinister weapon sucks the life force of your enemies like a vacuum cleaner" "Using this weapon will allow you to poison your enemies with every strike" "Inflict immense pain on your enemies with every strike, but the agony will also spread to your own body" "Summon the flames of steel to engulf your enemies" "This weapon looks deadly, but is not capable of injuring" "This weapon is designed for the strongest warriors" "This dime weapon does not hurt physically, but psychologically, and not enemies, but the owner of the weapon")

function GEN_W_DESCR {
    local ID=$(RANDINT 1 7)
    echo ${W_DESCRS[$(( $ID - 1 ))]}
} 

A_DESCRS=("This armor featuring a few decorative elements and providing maximum protection for the wearer" "This armor providing modest protection against injuries and no more" "This armor does not protect enough but displaying the wearer has colors or heraldry" "Armor that protects bodys and saves lifes")

function GEN_A_DESCR {
    local ID=$(RANDINT 1 4)
    echo ${A_DESCRS[$(( $ID - 1 ))]}
} 

RES_DESCR=("This resource is easy to find" "This resource has a value that makes it hard to find" "This resource is found in dungeons")

function GEN_RESOURCE {
    local R_ID=$(GEN_RAR_ID)
    local R_DESCR=${RES_DESCR[$(( $R_ID - 1 ))]}
    echo "($R_ID, '$(GEN_ITEM_NAME)', '$R_DESCR')" 
}

RECIPE_DESCRIPTIONS=("Common materials, low quality item" "Rare materials, high quality item" "Epic materials, high quality item with special properties")

function GEN_RECIPE_TYPE {
    echo $(RANDINT 0 2)
}
function GEN_RECIPE {
    local ITEM_NAME=$1
    local RAR_ID=$(GEN_RAR_ID)
    local ADJ=$(GEN_ADJECTIVE)
    local ADJ=${ADJ^}
    local DESC=${RECIPE_DESCRIPTIONS[(( $RAR_ID - 1 ))]}
    local NAME="$ITEM_NAME $ADJ Recipe"
    echo "($RAR_ID, $LAST_ITEM_ID, '$NAME', '$DESC')"
}
function GEN_REC_N {
    local NUMS=(2 2 3 4 5)
    local PERS=(80 5 5 5 5)
    echo $(RANDELBYPERCENTAGE PERS NUMS)
}
function GEN_RES_N {
    echo $(RANDINT 2 10) 
}
function GEN_REC_RES {
    local REC=$1
    local RES=$2
    echo "($REC, $RES)"
}
function INS_RES {
    local RES=$($PSQL "INSERT INTO resource_detail (rarity_id, name, description) VALUES $(GEN_RESOURCE)")
    if [ "$RES" = "INSERT 0 1" ]
    then 
    LAST_RES_ID=$(( $LAST_RES_ID + 1 ))
    fi
    echo $LAST_ITEM_ID RESOURCE
}
function INS_REC {
    local ITEM_NAME=$1
    local RES=$($PSQL "INSERT INTO recipe_detail (rarity_id, item_id, name, description) VALUES $(GEN_RECIPE "$ITEM_NAME")")
    echo $RES
}
function INS_REC_RES {
    local RAND_RES=$(RANDINT 1 $LAST_RES_ID)
    RES=$($PSQL "INSERT INTO recipe_resource VALUES ($LAST_REC_ID, $RAND_RES)")
    echo $RES
}
function INS_SKIN {
    local RES=$($PSQL "INSERT INTO skin (name, color_one, color_two) VALUES $(GEN_SKIN)") 
    if [ "$RES" = "INSERT 0 1" ]
    then 
    LAST_ITEM_ID=$(( $LAST_ITEM_ID + 1 ))
    LAST_SKIN_ID=$(( $LAST_SKIN_ID + 1 ))
    fi
    echo $LAST_ITEM_ID SKIN
}
function GEN_WEAPON {
    local NAME=$1
    echo "($(GEN_RAR_ID), $(GEN_SKIN_ID), $(GEN_W_T_ID), $(GEN_W_C_ID), '$NAME', '$(GEN_W_DESCR)')"
}
function INS_WEAPON {
    local NAME=$(GEN_ITEM_NAME)
    local RES=$($PSQL "INSERT INTO weapon_detail (rarity_id, skin_id, type_id, class_id, name, description) VALUES $(GEN_WEAPON "$NAME")") 
    if [ "$RES" = "INSERT 0 1" ]; then 
        LAST_ITEM_ID=$(( $LAST_ITEM_ID + 1 ))
        echo $LAST_ITEM_ID WEAAP
    fi
    for (( rec_n = 1; rec_n <= $(GEN_REC_N); rec_n++ )); do
        local RES=$(INS_REC "$NAME")
        if [ "$RES" = "INSERT 0 1" ]
        then 
        # LAST_REC_ID=$(expr $LAST_REC_ID + 1)
        LAST_REC_ID=$(( $LAST_REC_ID + 1 ))
        fi
        echo "$LAST_REC_ID REC ($RES)"
    if [ "$RES" = "INSERT 0 1" ]; then 
        for (( res_n = 1; res_n <= $(GEN_RES_N); res_n++ )); do
        local RES=$(INS_REC_RES)
        if [ "$RES" = "INSERT 0 1" ]
        then 
        echo REC_RES 
        else
        echo REPEATED
        fi
        done
    fi
    done
}
function GEN_ARMOR {
    local NAME=$1
    echo "($(GEN_RAR_ID), $(GEN_SKIN_ID), $(GEN_A_T_ID), $(GEN_A_C_ID), '$NAME', '$(GEN_A_DESCR)')"
}
function INS_ARMOR {
    local NAME=$(GEN_ITEM_NAME)
    local RES=$($PSQL "INSERT INTO armor_detail (rarity_id, skin_id, type_id, class_id, name, description) VALUES $(GEN_ARMOR "$NAME")") 
    if [ "$RES" = "INSERT 0 1" ]
        then 
        LAST_ITEM_ID=$(( $LAST_ITEM_ID + 1 ))
        echo $LAST_ITEM_ID ARM
    fi
    for (( rec_n = 1; rec_n <= $(GEN_REC_N); rec_n++ )); do
        local RES=$(INS_REC "$NAME")
        if [ "$RES" = "INSERT 0 1" ]
            then 
            # LAST_REC_ID=$(expr $LAST_REC_ID + 1)
            LAST_REC_ID=$(( $LAST_REC_ID + 1 ))
        fi
        echo "$LAST_REC_ID REC ($RES)"
        if [ "$RES" = "INSERT 0 1" ]; then 
            for (( res_n = 1; res_n <= $(GEN_RES_N); res_n++ )); do
                local RES=$(INS_REC_RES)
                if [ "$RES" = "INSERT 0 1" ]
                    then 
                    echo REC_RES 
                    else
                    echo REPEATED
                fi
            done
        fi
    done
}

function GEN_TREASURE {
    echo "($(GEN_RAR_ID), '$(GEN_ITEM_NAME)', '$(RANDELBYPERCENTAGE TREAS_PERCENTAGE TREAS_DESCR)')" 
}
function INS_TREASURE {
    local RES=$($PSQL "INSERT INTO treasure_detail (rarity_id, name, description) VALUES $(GEN_TREASURE)")
    if [ "$RES" = "INSERT 0 1" ]
        then 
        LAST_ITEM_ID=$(( $LAST_ITEM_ID + 1 ))
        echo $LAST_ITEM_ID TR
    fi
}

POT_DESCR=("This potion has almost no properties" "This is a medium quality potion" "This potion is of acceptable quality" "This is the highest quality potion")
POT_PERCENTAGE=(60 20 10 10)

GEN_POTION() {
    echo "($(GEN_RAR_ID), '$(GEN_ITEM_NAME)', '$(RANDELBYPERCENTAGE POT_PERCENTAGE POT_DESCR)')"
}
GEN_POT_IMP() {
    local ID=$1
    local PROP_ID=$(RANDINT 1 $PROPS_NUM) 
    local GAIN=$(( $(RANDINT 1 6) * 10 ))
    local TIME=$(RANDINT 10 30)
    echo "($ID, $PROP_ID, $GAIN, '00:00:$TIME')"
}
function INS_IMP {
    local POTION_ID=$1
    for (( n = 0; n < $(RANDINT 1 2); n++ )); do
        local RES=$($PSQL "INSERT INTO potion_impact (potion_id, property_id, gain, action_time) VALUES $(GEN_POT_IMP $POTION_ID)")
        if [ "$RES" = "INSERT 0 1" ]; then 
            echo P_I
        fi
    done
}
function INS_POTION {
    local RES=$($PSQL "INSERT INTO potion_detail (rarity_id, name, description) VALUES $(GEN_POTION)")
    if [ "$RES" = "INSERT 0 1" ]
        then 
        LAST_ITEM_ID=$(( $LAST_ITEM_ID + 1 ))
        LAST_POT_ID=$(( $LAST_POT_ID + 1 ))
        II_RES=$(INS_IMP $LAST_POT_ID)
        echo $LAST_ITEM_ID POT
    fi
}

for (( n = 0; n < 20; n++ )); do
    INS_RES
done
for (( n = 0; n < 50; n++ )); do
    INS_SKIN
done
for (( n = 0; n < 20; n++ )); do
    INS_WEAPON
    INS_ARMOR
    INS_TREASURE
    INS_POTION
done
