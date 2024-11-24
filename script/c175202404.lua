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
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end

function s.stfilter(c)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControlerCanBeChanged()
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExistingMatchingCard(s.stfilter,tp,0,LOCATION_MZONE,1,nil)
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