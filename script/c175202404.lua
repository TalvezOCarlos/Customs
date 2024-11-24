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
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(s.nscon)
	e3:SetTarget(s.nstg)
	e3:SetOperation(s.nsop)
	e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(s.syncon)
	e5:SetTarget(s.syntg)
	e5:SetOperation(s.synop)
	e5:SetCountLimit(1,{id,2})
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
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
	local trig_p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
	return re and re:IsActivated() and trig_p==tp and (Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2)>0
end
function s.synfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg,2,2)
end
function s.synmatfilter(c)
	return c:IsCanBeSynchroMaterial() and c:IsType(TYPE_SPIRIT)
end
function s.filter(tc,c,tp)
	local mg=Group.FromCards(c,tc)
	return tc:IsFaceup() and tc:IsCanBeSynchroMaterial()
		and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=Duel.GetMatchingGroup(s.synmatfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,sg,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,sg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,sg,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetMatchingGroup(s.synmatfilter,tp,LOCATION_MZONE,0,nil)
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)then
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,mg,2,2)
		end
	end
end