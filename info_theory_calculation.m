%%
load('3b_prob_data.mat');

%%
Shannon_E = -sum(dat_3b.*log(dat_3b),2,'omitnan');
%%
[~,low2high_3b_Ent] = sort(Shannon_E);

%%
st = 1;
ed = 780*2;
obj_rel_lr = obj_rel_matrix_pdf(:,st:ed);
Shannon_E_OR_LR = -sum(obj_rel_lr.*log(obj_rel_lr),2,'omitnan');
[~,low2high_OR_Ent_lr] = sort(Shannon_E_OR_LR);