# Gaussian Process Regression
## 1. Definition of GP
### Definition
- In probability theory and statistics, a Gaussian process is a stochastic process (a collection of random variables indexed by time or space), such that **every finite collection of those random variables has a multivariate normal distribution**, 
i.e. every finite linear combination of them is normally distributed. The distribution of a Gaussian process is the joint distribution of all those (infinitely many) random variables, and as such, it is a **distribution over functions with a continuous domain**, e.g. time or space.  
- Gaussian processes can be seen as an `infinite-dimensional MVN`.
- Gaussian processes are useful in statistical modelling, benefiting from properties inherited from the normal distribution. 
<p align="center"> <img width="334" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/6e5571a2-93a2-4cb7-8122-7a71a4494a67"> </p>

### Comparison with Gaussian distribution.
- GP를 Gaussian dist처럼 표현하면 다음과 같다.
<p align="center"> <img width="592" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/acd3d264-51a8-4bb0-97a5-c758d1f734ec"> </p>

- 아래 그림과 같이 함수 $m, k$에 의해 각 점에서 가우시안 분포를 가지게 되면 음영으로 표시된 것 같이 영역을 가지게 된다. 특정 데이터 하나가 아닌 확률 분포를 가지게 됨.
<p align="center"> <img width="627" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/a36ed9c5-e0da-408c-91d4-03fda8619d20"> </p>

- GP sample은 Gaussian dist처럼 하나의 값이 아니라 function 하나가 GP sample이다. (Stochastic process) (왼쪽 Gaussian distribution, 오른쪽 Gaussian Process)

<figure class="half">
    <img width="408" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/dda73679-fbc3-4c19-b51a-495b6f8c41ed"> 
    <img width="231" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/ddfc67f5-4b57-461e-979a-f6f3edca16d6">
  
#### Reference
  - https://en.wikipedia.org/wiki/Gaussian_process
  - https://gaussian37.github.io/ml-concept-gaussian_process/
    
    
    
    
## 2. GP regression
reference
 - https://cs229.stanford.edu/section/cs229-gaussian_processes.pdf
 - https://www.apps.stat.vt.edu/leman/VTCourses/GPtutorial.pdf
