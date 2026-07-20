import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class DeleteBudget implements UseCase<Unit, DeleteBudgetParams> {
  final BudgetRepository repository;

  const DeleteBudget(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteBudgetParams params) {
    return repository.deleteBudget(params.id);
  }
}

class DeleteBudgetParams extends Equatable {
  final String id;

  const DeleteBudgetParams(this.id);

  @override
  List<Object> get props => [id];
}