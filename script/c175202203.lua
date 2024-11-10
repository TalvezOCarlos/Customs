-- ギガンティック・スプライト
-- Gigantic Splight
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- 2 Level 4 Useless monsters
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xa12f),4,2)
    c:EnableReviveLimit()
	-- Name Change
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE|LOCATION_GRAVE)
	e1:SetValue(175202201)
	c:RegisterEffect(e1)
    -- Send from gy to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
    e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0xa12f}
s.listed_names={175202201}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
    e:GetHandler():RemoveOverlayCard(tp,1,REASON_COST)
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function s.filter(c)
    return c:IsSetCard(0xa12f) and c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if Duel.SelectYesNo(tp, aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end 
