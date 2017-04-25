[slide 0] "Title page"
- Today I thought I'd talk about one of the projects I've been working on recently;
- This is one of the projects in my PhD work;
- In fact, it also my favourite project;
- Bayesian inference of trees via MCMC faster and more reliable;
- Hopefully by the end i'll have convinced you that estimating trees is hard and in addition that the methods we developed in this project are a step in the right direction.

[slide 1] "Acknowledgements"
- But the best work is seldom done in isolation;
- I must acknowledge the help of three very smart gentlemen.

[slide 2] "Motivation"
- OK. So why are we interested in trees -- or phylogenies, I'll use both terms interchangeably -- to begin with?
- Well, there are plenty of reasons, but I'll stick to the ones relevant to the work done in my group;
- In our group we are interested in the evolution of emerging human viral pathogens, in particular, fast evolving RNA viruses that have been sampled through time;
- These questions are addressed by the field of Phylodynamics;
- In particular, this means inferring evolutionary and population dynamic processes from molecular sequence data;
- The figures here illustrate how one can relate variation in population size through time and population structure to phylogenies;
- An important feature of these trees, however, is that their branch lengths are measured in units of calendar time;
- In addition, because sequences are usually sampled through time, there are restrictions on the tree. I might return to this later on;

[slide 3] "Trees are hypotheses"
-  Trees are hypotheses about the evolutionary path that generated the data;
- So in this case we have three hypotheses for how these three species of great apes came about;
- In this case we have evidence that the middle tree is correct, meaning that firt gorillas diverged from their common ancestor with us and chimps and then humans and chimps diverged from their common ancestor.

[slide 4] "The gist of Bayesian phylogenetics"
- From a statistical point of view, however, I think it's easier to think about trees as parameters in a model;
- In fact, this notion is central to phylodynamics, since mostly every parameter is defined *conditional*  on the tree;
- So here we have the joint space of trees and continuous parameters Omega. Examples of parameters in omega range from the transition transversion parameter kappa to growth and migration rates;
- The Bayesian approach in general is about marginalisation, as opposed to maximising a score function -- the likelihood function for instance;
- Hence, once you've painstakingly sampled from the joint distribution of trees and omega, you can marginalise to get the distributions of either trees or omega;
- This is illustrated here;
- Notice the distribution of Omega for instance looks a bit weird. This is on purpose, to illustrate one of the main features of Bayesian phylogenetics: accommodating phylogenetic uncertainty;
- As we've seen in the previous slide, sometimes you are really sure what the right tree is -- at least regarding the branching order -- but I think it's easy for you to imagine situations where you don't really know how to arrange some clades;
- So the distribution of omega here accounts for that uncertainty by integrating over the space of probable phylogenies;
- This concept is key to the next slide and the remainder of the talk.

[slide 5] "Tree space: a strange land"
- Right. But how do we integrate over the space of trees?
- We've got to traverse the space of all trees and visit each tree proportional to its posterior probability;
- Easier said than done, though. For 53 taxa there are more trees than there are atoms in the observable Universe;
- Here we have two illustrations of this "tree space". It's hard even to visualise, man...
- In your left hand side you can see a representation where we plot two dimensions of tree space, say principal components and make the zed axis the likelihood;
- Another way of looking at this space is to construct a graph (network) where every vertex is a tree and there's an edge between two trees if they can be reached from one another using a particular tree rearrangement. In this case this is the SPR graph, where two trees are connected if we can go from one to the other by pruning a subtree and regrafting is somewhere else.

[slide 6] "Metropolis-Hastings algorithm"
- The basic idea of MH is to sample from a distribution by looking at *ratios* of densities, rather than the actual densities;
- This avoids nasty normalising constants and ensures we sample from the right target under some regularity conditions.

[slide 7] "MCMC robot"
- The algorithm I showed in the previous slide leads to a "MCMC robot", basically a scanning procedure that navigates the target distribution proportional to the true density;
- This means uphill steps are always accepted, because you want to sample from the bulk of the distribution (aka typical set);
- Similarly, slight downhill steps are also accepted sometimes. REMEMBER: this is not maximisation, we are trying to explore the whole distribution here;
- Finally, MH is constructed to avoid drastic moves away from the bulk, so "off the cliff" moves occur with vanishing probability.

[slide 8] "Exploring parameter space: burn-in"
- to explore the target distribution, however we first need to find it;
- The chain usually needs some time to "burn-in", i.e., find the bulk of the target distribution;
- This important because we need to remove this period from the chain to get proper samples and make accurate inferences. 

[slide 9] "Exploring parameter space: mixing"
- we need to strike a balance between being bold and rejecting too many moves and being too conservative and not exploring the target properly;
- In the continuous case, this is done by tuning the variance of the transition kernel: the larger the variance the bolder we are;
- A detail important to mention is that the best MCMC algorithms are adaptative, i.e, they "tune" the variance during the chain, so as to achieve a desired acceptance probability;
- For trees, however, things are not quite so simple, as you might imagine. 

[slide 10] "Height-preserving kernels: subTreeLeap"
- SubTreeLeap respects the restrictions on the tip dates, it doesn't generate invalid trees;
- The variance of the distance kernel (the distribution in blue) can be tuned during the chain to control the boldness of the steps.
- STL has an evil twin, SubTreeJump, that shall remain in the shadows due to time constraints.

[slide 11-13] "Results"
- We are showing ESS/hour, so higher is better;
- I show two parameters: one that usually mixes well and another that is harder to sample;
- each box plot pertains to 100 chains, started from random trees;
- 
[slide 14] "Metazoans"
- extra result showing STL can be helpful even when dealing with contemporaneous sequences.

[slide 15] "Take home"
- searching tree space is hard;
- height-preserving and tuning are very desirable properties;
- Loads of data is being generated and much more is coming, we need to prepare (method-wise).

