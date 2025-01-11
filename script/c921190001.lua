
local s,id=GetID()
function s.initial_effect(c)
	-- ADD TO HAND
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.thtg)
    e1:SetCondition(s.thop)
	c:RegisterEffect(e1)
    -- SUMMON FROM GY

    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_LEAVE_GRAVE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY + EFFECT_FLAG2_CHECK_SIMULTANEOUS)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(s.spcon)
    e2:SetCost(s.spcos)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    
end
s.listed_series={0x21f}
s.listed_names={921190003}

function s.thfilter(c)
	return c:ListsCode(921190003) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand(),tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.spfilter(c)
    return c:IsCanBeSpecialSummoned(c,e,TYPE_SPSUMMON, 1, false) and c:IsSetCard(921190003)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.spfilter, 1, nil, e, tp) 
end

function s.spcos(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c = e:GetHandler()
    if chk == 0 then return c.IsAbleToRemoveAsCost() end 
    Duel.Sendto(c, LOCATION_REMOVED, REASON_COST, POS_FACEUP)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    
    local c=e:GetHandler()

    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and eg:IsExists(s.spfilter,1,nil,e,tp) end

    Duel.SetTargetCard(c)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc = Duel.GetFirstTarget()
    Duel.SpecialSummon(tc, SUMMON_TYPE_SPECIAL, 1, 1, false, false)
end
