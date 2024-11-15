-- Useless Gloves
-- Designed and Scripted by TalvezOCarlos
local s,id=GetID()
function s.initial_effect(c)
	--Equip Procedure
    aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xa12f))
	--Add a "Useless" card from GY to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.mlcos)
	e1:SetTarget(s.mltg)
	e1:SetOperation(s.mlop)
	c:RegisterEffect(e1)
	--Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(511001175)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.listed_series={0xa12f}
function s.mlcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function s.mltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.mlfh(c)
    return c:IsSetCard(0xa12f) and c:IsAbleToHand()
end
function s.mlop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if Duel.SelectYesNo(tp, aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.mlfh,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end

end