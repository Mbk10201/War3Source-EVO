// War3Source_Engine_WCX_Engine_Bash.sp

/* Plugin Template generated by Pawn Studio */

//#include <war3source>
//#assert GGAMEMODE == MODE_WAR3SOURCE

new PlayerRace[MAXPLAYERSCUSTOM];
/*
public Plugin:myinfo =
{
	name = "WCX Bash",
	author = "necavi",
	description = "WCX Bash",
	version = "0.1",
	url = "http://necavi.com"
}*/

public War3Source_Engine_WCX_Engine_Bash_OnPluginStart()
{
	LoadTranslations("w3s.race.humanally.phrases");
}

// modified because W3ChanceModifier() may not work with this:
//public OnWar3EventPostHurt(victim,attacker,damage,const String:weapon[32],bool:isWarcraft){
public OnW3TakeDmgAll(victim,attacker,Float:damage){
	//new dmg=RoundToCeil(damage);
	if(IS_PLAYER(victim)&&IS_PLAYER(attacker)&&victim>0&&attacker>0&&attacker!=victim)
	{
		// Not sure why prevent these weapons?
		//decl String:weapon[64];
		//GetEventString(W3GetVar(SmEvent),"weapon",weapon,63);
		//if(StrEqual(weapon, "crit",false) || StrEqual(weapon, "bash", false) || StrEqual(weapon, "weapon_crit",false) || StrEqual(weapon, "weapon_bash", false))
			//return;

		new vteam=GetClientTeam(victim);
		new ateam=GetClientTeam(attacker);
		if(vteam!=ateam)
		{
			new Float:percent = GetBuffSumFloat(attacker,fBashChance);
			if((percent > 0.0) && !Hexed(attacker) && W3Chance(fChanceModifier(attacker)))
			{
				// Bash
				if(War3_Chance(percent) && !GetBuffHasOneTrue(victim,bBashed) && IsPlayerAlive(attacker))
				{
					if(!W3HasImmunity(victim,Immunity_Skills))
					{
						new race=GetRace(victim);
						PlayerRace[victim] = race;
						SetBuffRace(victim,bBashed,race,true,attacker);
						new newdamage = GetBuffSumInt(attacker,iBashDamage);
						if(newdamage>0)
							DealDamage(victim,newdamage,attacker,_,"weapon_bash");

						W3FlashScreen(victim,RGBA_COLOR_RED);
						new Float:duration = GetBuffSumFloat(attacker,fBashDuration);
						CreateTimer(duration,UnfreezePlayer,victim);

						PrintHintText(victim,"%T","RcvdBash",victim);
						PrintHintText(attacker,"%T","Bashed",attacker);
					}
					else
					{
						War3_NotifyPlayerImmuneFromSkill(attacker, victim, 0);
					}
				}
			}

		}
	}
}

public Action:UnfreezePlayer(Handle:h,any:victim)
{
	SetBuffRace(victim,bBashed,PlayerRace[victim],false);
}



