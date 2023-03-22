INSERT INTO rarity (name) VALUES ('Common'), ('Rare'), ('Epic');

INSERT INTO coin (name) VALUES  ('Gold'), ('Silver'), ('Copper');

DO $$ BEGIN 
    FOR rarity IN 1..3 LOOP 
        FOR coin IN 1..3 LOOP 
            INSERT INTO price (rarity_id, coin_id, cost) VALUES (rarity, coin, trunc(random()*10)*rarity*coin*100); 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

INSERT INTO role (description) VALUES ('Player'), ('Administrator'); 

INSERT INTO race (name, description) VALUES 
('Human', 'This race is characterized by high levels of strength.'), 
('Elf', 'This race is characterized by high levels of mana.'), 
('Beastman', 'This race is characterized by high levels of stamina.');

INSERT INTO class (name, description) VALUES 
('Mage', 'Mages have the highest level of mana.'), 
('Hunter', 'Hunters have the highest level of endurance.'), 
('Warior', 'Wars are distinguished by the highest level of damage dealt.');

INSERT INTO reason (description) VALUES ('Offensive Language'), ('Friendly Damage'); 

INSERT INTO penalty (description) VALUES ('Game Ban'), ('Account Deletion'); 

INSERT INTO report_status (description) VALUES ('Rejected'), ('Accepted'), ('Punished');

INSERT INTO ban (penalty_id, duration, description) VALUES 
(1, INTERVAL '10 minutes', 'Simple Punishment'), 
(1, INTERVAL '100 hours', 'Severe Punishment'), 
(2, NULL, 'Permanent Punishment');

INSERT INTO property (name, description) VALUES  
('Damage', 'This is an attribute of weapons.'), 
('Attack Speed', 'This is an attribute of weapons.'), 
('Mana Cost', 'This is an attribute of weapons.'), 
('Weight', 'This is an attribute of weapons and armor.'), 
('Defence', 'This is an attribute of armor.'), 
('Frost Resist', 'This is an attribute of armor.'), 
('Heat Resist', 'This is an attribute of armor.'), 
('Mana', 'This is an attribute of character.'), 
('Stamina', 'This is an attribute of character.'), 
('Strength', 'This is an attribute of character and enemy.'), 
('Health', 'This is an attribute of character and enemy.');

INSERT INTO armor_class (name, description) VALUES 
('Cloth', 'Cloth armor is the only armor type that can be worn by characters with any level of power. Cloth armor has the lowest armor attribute, below leather armor.'), 
('Leather', 'Leather armor provides more protection than cloth armor, but less than mail or plate armor.'), 
('Chain Mail', 'Mail armor is a type of armor that consists of small metal rings fashion together to form a mesh, which is then fashioned in to coverings for the various parts of the body.'), 
('Plate', 'Plate armor is the heaviest type of armor which is created from solid sheets of metal.');

INSERT INTO armor_type (name, description) VALUES 
('Head', 'Helms is an armor piece that is worn on the head for protection.'), 
('Chest', 'Chest Armor refers to armor that can be equipped in the chest armor slot.'), 
('Hands', 'Gauntlets is an armor piece that is worn to protect the players hands from damage.'), 
('Legs', 'Leg Armor is an armor piece that is worn by the player to protect the legs from damage.');

INSERT INTO weapon_class (name, description) VALUES 
('Axes', 'Axes are very similar to the straight swords that only slash. The main difference is that axes mainly do damage based on strength, while the damage of straight swords depends on both strength and dexterity.'), 
('Hammers', 'Hammers generally do more physical damage and poise damage than axes or straight swords, but their attack animations can be slightly awkward to hit with. For the most part, hammers do Strike damage and depend on strength.'), 
('Pikes', 'Spears are excellent weapons for tactical combat, as most pikes one-handed light attacks can be used while still blocking and their range is impressive.'), 
('Straight Swords', 'Ordinary swords with a balance of standard and thrust attacks.'), 
('Curved Swords', 'Curved Swords have shorter range than other swords but are slightly faster. They are well-suited to confined spaces against lightly armored enemies who will be unable to dodge or block the rapid attacks, but their slashing-oriented movesets are ineffective against heavier armor.'), 
('Thrusting Swords', 'Thrusting swords in general have a thin blade, like the Rapier. Obviously, they focus on thrusts, and as such have trouble against enemies who dodge to the side often.'), 
('Daggers', 'Daggers have short range, but are extremely rapid and have high critical potential. They are best-suited towards tactical fighters with a penchant for counters and backstabs.'), 
('Staves', 'Staves are primarily used to cast sorceries. They can also be used as melee weapons when executing their strong attack.');

INSERT INTO weapon_type (name, description) VALUES 
('Melee', 'A type of weapon that specializes in close combat.'), 
('Ranged', 'A type of weapon that specializes in long-range combat.');

DO $$ BEGIN 
    FOR a_type IN 1..4 LOOP 
        FOR a_class IN 1..4 LOOP 
            FOR a_prop IN 4..7 LOOP 
                INSERT INTO def_armor_stat VALUES (a_class, a_type, a_prop, trunc(random()*100)); 
            END LOOP; 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

DO $$ BEGIN 
    FOR w_prop IN 1..4 LOOP 
        FOR w_class IN 1..8 LOOP 
            FOR w_type IN 1..2 LOOP 
                INSERT INTO def_weapon_stat VALUES (w_type, w_class, w_prop, trunc(random()*100)); 
            END LOOP; 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

DO $$ BEGIN 
    FOR u_prop IN 8..11 LOOP 
        FOR u_class IN 1..3 LOOP 
            FOR u_race IN 1..3 LOOP 
                INSERT INTO def_character_stat VALUES (u_race, u_class, u_prop, trunc(random()*100)); 
            END LOOP; 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

INSERT INTO location (name, description) VALUES 
('Suburb', 'The suburb is a location with regular NPCs and merchants.'), 
('Forest', 'The forest is a location with weak monsters and variety of crafting resources.'), 
('Dungeon', 'The dungeon is a location filled with strong monsters and rare treasures.');

INSERT INTO enemy (name, experience, description) VALUES 
('Slime', 100, 'This is type of enemies living in caves and forests.'), 
('Beast', 100, 'This is type of enemies living forests.'), 
('Demon', 100, 'This is type of enemies living in caves and forests.'), 
('Troll', 100, 'This is type of enemies living in caves.'), 
('Orc', 100, 'This is type of enemies living in swamps and forests.'), 
('Ogre', 100, 'This is type of enemies living in caves and forests.'), 
('Goblin', 100, 'This is type of enemies living in caves and forests.');

DO $$ BEGIN 
    FOR enemy IN 1..7 LOOP 
        FOR loc IN 1..3 LOOP 
            INSERT INTO enemy_location (enemy_id, loc_id, spawn_rate) VALUES (enemy, loc, trunc(random()*10)+(loc-1)*trunc(random()*1000)); 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

DO $$ BEGIN 
    FOR enemy IN 1..7 LOOP 
        FOR prop IN 10..11 LOOP 
            INSERT INTO enemy_stat (enemy_id, property_id, value) VALUES (enemy, prop, trunc(random()*10000)); 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

INSERT INTO chest_type (size, displacement, description) VALUES 
(2, INTERVAL '10 minutes', 'Tiny'), 
(8, INTERVAL '20 minutes', 'Medium'), 
(12, INTERVAL '30 minutes', 'Large');

DO $$ BEGIN 
    FOR rarity IN 1..3 LOOP 
        FOR chest IN 1..3 LOOP 
            INSERT INTO drop_rate VALUES (chest, rarity, trunc(random()*100/chest)); 
        END LOOP; 
    END LOOP; 
END $$ LANGUAGE plpgsql;

INSERT INTO npc_type (description) VALUES ('Butcher'), ('Carpenter'), 
('Drunkard'), ('Innkeeper'), ('Peasant'), ('Stableman'), 
('Villager'), ('Townsman'), ('Guardsman'), ('Forester');

INSERT INTO slot (description) VALUES ('Head armor item'), 
('Chest armor item'), ('Hands armor item'), ('Legs armor item'), 
('Quick use item'), ('Primary weapon item'), ('Secondary weapon item');