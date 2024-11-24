-- Anima Projector Creatio
-- Scripted and Designed by TalvezOCarlos
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SPIRIT),1,1,Synchro.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
    -- Steal
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	-- Normal Summon 1 Spirit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.nscon)
	e3:SetTarget(s.nstg)
	e3:SetOperation(s.nsop)
	e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
	-- Synchro Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(s.syncon)
	e4:SetTarget(s.syntg)
	e4:SetOperation(s.synop)
	e4:SetCountLimit(1,{id,2})
	c:RegisterEffect(e4)
end
s.listed_series{0xa13f}
function s.stfilter(c)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControlerCanBeChanged() and c:IsFaceup()
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.stfilter,1,nil)
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,s.stfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.GetControl(tc,tp,nil,1)
	end
end
function s.nsfilter(c)
    return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT)
end
function s.nscon(e,tp,eg,ep,ev,re,r,rp)
	local trig_p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
	return re and re:IsActivated() and trig_p==1-tp and (Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2)>0
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sg1=Duel.GetMatchingGroup(s.nsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
    if #sg1>0 then
		Duel.BreakEffect()
        Duel.ShuffleHand(tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local sg2=sg1:Select(tp,1,1,nil):GetFirst()
        Duel.Summon(tp,sg2,true,nil)
    end
end
function s.syncon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2)>0
end
function s.synfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg,2,2) and c:IsSetCard(0xa13f)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end