-- Anima Projector Florere
-- Scripted and Designed by TalvezOCarlos
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon 1 level 4 Anima Project from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    -- Draw for each Anima Project Monster
 --   local e2=Effect.CreateEffect(c)
--	e2:SetDescription(aux.Stringid(id,1))
--	e2:SetCategory(CATEGORY_DRAW)
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
--	e2:SetProperty(EFFECT_FLAG_DELAY)
--	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
--	e2:SetRange(LOCATION_MZONE)
--	e2:SetCountLimit(1,{id,1})
--	e2:SetTarget(s.drwtg)
--	e2:SetOperation(s.drwop)
--	c:RegisterEffect(e2)
end

s.listed_series={0xa13f}
function s.spconfilter(c)
    return c:IsType(TYPE_SPIRIT) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.dfilter(c)
    return c:IsSetCard(0xa13f) and c:IsFaceup()
end
--function s.drwtg(e,tp,eg,ep,ev,re,r,rp,chk)
  --  local ct=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MMZONE,0,nil):GetClassCount(Card.GetCode)
	--if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	--Duel.SetTargetPlayer(tp)
	--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
--end
--function s.drwop(e,tp,eg,ep,ev,re,r,rp)
--	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
--	local ct=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MMZONE,0,nil):GetClassCount(Card.GetCode)
--	if ct>0 then
--		Duel.Draw(p,ct,REASON_EFFECT)
--	end
--end